/**
 * CoZjem Camera Utility
 * Captures a camera stream snapshot and sends it to the /api/analyze-fridge endpoint.
 */

const API_BASE_URL = process.env.API_BASE_URL ?? 'http://localhost:8000';

export interface Ingredient {
  name: string;
  category: string;
  confidence: string;
}

export interface FridgeAnalysisResponse {
  ingredients: Ingredient[];
}

/**
 * Requests camera access and returns a MediaStream.
 * @throws {Error} if camera permission is denied or no camera is available
 */
export async function getCameraStream(
  constraints: MediaStreamConstraints = { video: { facingMode: 'environment' }, audio: false }
): Promise<MediaStream> {
  if (!navigator.mediaDevices?.getUserMedia) {
    throw new Error('getUserMedia is not supported in this browser.');
  }

  try {
    return await navigator.mediaDevices.getUserMedia(constraints);
  } catch (err: unknown) {
    if (err instanceof DOMException) {
      if (err.name === 'NotAllowedError' || err.name === 'PermissionDeniedError') {
        throw new Error(
          'Camera access denied. Please allow camera permissions and try again.'
        );
      }
      if (err.name === 'NotFoundError' || err.name === 'DevicesNotFoundError') {
        throw new Error(
          'No camera found on this device.'
        );
      }
      if (err.name === 'NotReadableError' || err.name === 'TrackStartError') {
        throw new Error(
          'Camera is already in use by another application.'
        );
      }
    }
    throw new Error(`Failed to access camera: ${(err as Error).message ?? err}`);
  }
}

/**
 * Attaches a MediaStream to a <video> element and waits for it to be ready.
 */
export async function attachStreamToVideo(
  stream: MediaStream,
  videoElement: HTMLVideoElement
): Promise<void> {
  videoElement.srcObject = stream;
  videoElement.setAttribute('playsinline', 'true');
  await videoElement.play();

  return new Promise((resolve) => {
    videoElement.addEventListener('canplay', () => resolve(), { once: true });
  });
}

/**
 * Takes a snapshot from a playing <video> element and returns it as a Blob.
 */
export async function takeSnapshot(
  videoElement: HTMLVideoElement,
  mimeType: 'image/jpeg' | 'image/png' = 'image/jpeg',
  quality = 0.9
): Promise<Blob> {
  const canvas = document.createElement('canvas');
  canvas.width = videoElement.videoWidth;
  canvas.height = videoElement.videoHeight;

  const ctx = canvas.getContext('2d');
  if (!ctx) {
    throw new Error('Failed to get 2D canvas context.');
  }
  ctx.drawImage(videoElement, 0, 0, canvas.width, canvas.height);

  return new Promise((resolve, reject) => {
    canvas.toBlob(
      (blob) => {
        if (blob) {
          resolve(blob);
        } else {
          reject(new Error('Failed to create image blob from canvas.'));
        }
      },
      mimeType,
      quality
    );
  });
}

/**
 * Sends an image Blob to the /api/analyze-fridge endpoint.
 */
export async function analyzeFridge(
  imageBlob: Blob,
  fileName = 'fridge.jpg',
  signal?: AbortSignal
): Promise<FridgeAnalysisResponse> {
  const formData = new FormData();
  formData.append('file', imageBlob, fileName);

  let response: Response;
  try {
    response = await fetch(`${API_BASE_URL}/api/analyze-fridge`, {
      method: 'POST',
      body: formData,
      signal,
    });
  } catch (err: unknown) {
    if ((err as Error).name === 'AbortError') {
      throw new Error('Request was cancelled.');
    }
    throw new Error(
      `Network error: Could not reach the server. ${(err as Error).message ?? ''}`
    );
  }

  if (!response.ok) {
    let detail: string;
    try {
      const errorBody = (await response.json()) as { detail?: string };
      detail = errorBody.detail ?? `HTTP error ${response.status}`;
    } catch {
      detail = `HTTP error ${response.status}`;
    }

    if (response.status === 400) {
      throw new Error(`Invalid file: ${detail}`);
    }
    if (response.status === 413) {
      throw new Error('File is too large. Maximum size is 10 MB.');
    }
    if (response.status === 503) {
      throw new Error('AI service is temporarily unavailable. Please try again later.');
    }
    throw new Error(`Server error: ${detail}`);
  }

  return response.json() as Promise<FridgeAnalysisResponse>;
}

/**
 * Stops all tracks in a MediaStream (releases camera).
 */
export function stopStream(stream: MediaStream): void {
  stream.getTracks().forEach((track) => track.stop());
}

/**
 * High-level helper: capture from camera and analyze fridge.
 * Creates a temporary <video> element, captures a frame, and sends it to the API.
 */
export async function captureAndAnalyze(signal?: AbortSignal): Promise<FridgeAnalysisResponse> {
  let stream: MediaStream | null = null;
  const video = document.createElement('video');
  video.style.display = 'none';
  document.body.appendChild(video);

  try {
    stream = await getCameraStream();
    await attachStreamToVideo(stream, video);
    const blob = await takeSnapshot(video);
    return await analyzeFridge(blob, 'fridge.jpg', signal);
  } finally {
    if (stream) stopStream(stream);
    document.body.removeChild(video);
  }
}
