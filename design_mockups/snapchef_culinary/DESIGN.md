# Design System Document: High-End Editorial Gastronomy

## 1. Overview & Creative North Star: "The Digital Sommelier"
This design system moves away from the clinical, "app-like" feel of standard recipe platforms and moves toward the tactile, immersive experience of a high-end modern cookbook. The **Creative North Star** is "The Digital Sommelier"—an interface that feels curated, knowledgeable, and effortlessly chic.

To achieve this, we reject the rigid, centered grid in favor of **intentional asymmetry**. We utilize high-contrast typography scales and "breathing layouts" where white space is as important as the content itself. By overlapping high-quality food photography with floating typography and organic containers, we create a sense of depth that feels "plated" rather than "programmed."

---

## 2. Colors & Surface Philosophy
The palette is a celebration of freshness. We use `primary` (#006e1c) for stability and `secondary` (#8b5000) for "juicy" highlights.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders to define sections. We define boundaries through:
- **Tonal Shifts:** Placing a `surface-container-low` card against a `surface` background.
- **Organic Negative Space:** Using the `Spacing Scale` (specifically `8` or `10`) to create a cognitive break between content blocks.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of fine paper. 
- **Base Layer:** `surface` (#f8faf8).
- **Secondary Content (e.g., Search bars):** `surface-container` (#eceeec).
- **Primary Cards (e.g., Recipe Cards):** `surface-container-lowest` (#ffffff) to create a natural, "bright" lift.

### The "Glass & Gradient" Rule
To elevate the "Modern Cookbook" feel, use **Glassmorphism** for floating headers or navigation bars. Use `surface` at 70% opacity with a `backdrop-blur` of 20px. 
**Signature Polish:** For main Action Buttons, apply a subtle linear gradient from `primary` (#006e1c) to `primary-container` (#4caf50) at a 135° angle to add "soul" and dimension.

---

## 3. Typography: Editorial Authority
We pair the geometric precision of **Plus Jakarta Sans** for headlines with the high readability of **Inter** for functional text.

*   **Display (Plus Jakarta Sans):** Used for recipe titles and hero headers. `display-lg` (3.5rem) should be used with tight letter-spacing (-0.02em) to mimic magazine mastheads.
*   **Headline (Plus Jakarta Sans):** `headline-md` (1.75rem) provides clear section entry points.
*   **Body (Inter):** `body-lg` (1rem) for instructions and descriptions. Maintain a generous line-height (1.6) to ensure the "Cookbook" legibility.
*   **Labels (Inter):** `label-md` (0.75rem) in All Caps with 0.05em tracking for metadata (e.g., "15 MINS", "EASY").

---

## 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are often too "heavy" for a fresh food brand. We use **Tonal Layering** and **Ambient Shadows**.

*   **The Layering Principle:** Instead of a shadow, place a `surface-container-lowest` card on a `surface-container-low` background. The slight delta in hex code creates a sophisticated "soft lift."
*   **Ambient Shadows:** For floating elements (like a "Start Cooking" FAB), use a blur of `32px`, an offset of `Y: 8`, and an opacity of `6%` using the `on-surface` color.
*   **The "Ghost Border" Fallback:** If accessibility requires a stroke, use `outline-variant` at **15% opacity**. Never use a 100% opaque border.
*   **Glassmorphism:** Use for "floating" nutritional info overlays on top of food imagery to maintain context without obscuring the "appetizing" visuals.

---

## 5. Components & Primitive Styling

### Buttons (The "Plated" Action)
*   **Primary:** Large radius (`full`), gradient fill (Primary to Primary-Container), `title-sm` white text. 
*   **Secondary:** `surface-container-highest` background with `primary` text. No border.
*   **Tertiary:** Ghost style; text-only with `primary` color and `600` weight.

### Cards & Lists (The "Anti-Grid" Approach)
*   **Recipe Cards:** Use `xl` (3rem) or `lg` (2rem) corner radius. Imagery must bleed to the edges. 
*   **Forbid Dividers:** Never use a horizontal line to separate ingredients. Use `spacing-4` (1.4rem) of vertical white space or a very subtle background shift to `surface-container-low`.

### Interactive Elements
*   **Chips (Filter/Tag):** Pill-shaped (`full`). Default state is `surface-container-high`. Active state is `secondary-container` (#ff9800) with `on-secondary-container` (#653900) text.
*   **Input Fields:** Avoid boxes. Use a `surface-container` background with a `lg` (2rem) radius. Labels should be `label-md` placed *outside* and above the input for an editorial look.

### Unique Components: "The Ingredient Floating Plate"
A custom component for this system: A horizontal scrolling list of ingredients where each item is a `surface-container-lowest` circle with a `soft shadow`, housing a high-res cutout of the ingredient.

---

## 6. Do’s and Don’ts

### Do:
*   **Use Oversized Imagery:** Let food photography take up 40-50% of the screen real estate.
*   **Embrace Asymmetry:** Offset a headline so it slightly overlaps a photo to create depth.
*   **Use Tonal Transitions:** Transition from a `surface` background to a `surface-container-low` section to denote a change in "chapter."

### Don't:
*   **Don't Use Pure Black:** Use `on-surface` (#191c1b) for text to keep the "Ink on Paper" feel.
*   **Don't Use 1px Dividers:** It breaks the high-end cookbook illusion. Use space.
*   **Don't Over-Shadow:** If more than two elements have shadows, the interface becomes cluttered. Rely on tonal shifts first.
*   **Don't Use Default Radius:** Avoid the standard 4px or 8px. Stay within the `lg` (2rem) to `xl` (3rem) range for a friendly, organic feel.