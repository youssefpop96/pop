# pop
ui training

https://github.com/user-attachments/assets/4fb3a908-b916-4116-b57b-99975f3d4a7d


A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Design System Specification: Luminous Ethereality

## 1. Overview & Creative North Star
**Creative North Star: "The Prismatic Sanctuary"**

This design system rejects the clinical coldness of traditional tech interfaces in favor of a "Prismatic Sanctuary"—a space that feels both cutting-edge and deeply tactile. By marrying the softness of organic, rounded geometry with the high-energy vibration of neon accents, we create an editorial experience that feels premium and intentional.

The system breaks the "template" look through **intentional layering and atmospheric depth**. We do not build grids; we compose environments. Through the use of mesh gradients and glassmorphism, we move away from flat, static layouts toward a UI that feels like light passing through high-end crystal.

---

## 2. Colors & Surface Logic

Our palette utilizes a high-contrast light mode base (`background: #eaf9ff`) punctuated by hyper-saturated "Neon" strikes.

### The "No-Line" Rule
Traditional 1px solid borders are strictly prohibited for structural sectioning. Boundaries must be defined through **Background Color Shifts** or **Tonal Transitions**. For instance, a `surface-container-low` section should sit against the `surface` background to create a boundary without a hard line.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers—like stacked sheets of frosted glass.
- **Level 0 (Base):** `surface` (#eaf9ff).
- **Level 1 (Sections):** `surface-container-low` (#dbf5ff).
- **Level 2 (Cards/Modules):** `surface-container-lowest` (#ffffff).
- **Level 3 (Interactive/Popovers):** `surface-bright` with Backdrop Blur.

### The "Glass & Gradient" Rule
To achieve "visual soul," use semi-transparent surface colors (60-80% opacity) combined with `backdrop-filter: blur(20px)`. 
- **Signature Textures:** For Hero sections or Primary CTAs, utilize a mesh gradient transitioning from `primary` (#006571) to `primary-container` (#00e3fd) to provide a shimmering, liquid-light effect.

---

## 3. Typography

The typographic voice is a dialogue between the technical precision of **Inter** and the expressive, geometric character of **Space Grotesk**.

*   **Display & Headlines (Space Grotesk):** These are your "Editorial Statements." Use `display-lg` (3.5rem) with tight letter-spacing (-0.02em) to command authority. The geometric nature of Space Grotesk mirrors the futuristic "Neon" aesthetic.
*   **Body & Labels (Inter):** Inter provides the functional "System" voice. It ensures high legibility against complex glass backgrounds. Use `body-md` (0.875rem) for general prose to maintain a sophisticated, airy feel.
*   **Hierarchy Note:** Always lead with high contrast. A `display-md` headline in `on-surface` (#003440) paired with a `label-md` in `secondary` (#9500c8) creates an immediate sense of high-end curation.

---

## 4. Elevation & Depth

We eschew traditional drop shadows for **Tonal Layering** and **Atmospheric Diffusion**.

*   **The Layering Principle:** Depth is achieved by "stacking" container tiers. Place a `surface-container-lowest` (#ffffff) card on a `surface-container-low` (#dbf5ff) section. This creates a soft, natural "lift" that feels integrated.
*   **Ambient Shadows:** If a floating effect is required (e.g., a Modal), use a shadow color tinted with `on-surface` at 5% opacity. Blur values must be expansive (30px–60px) to mimic natural ambient light.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility, use the `outline-variant` token (#82b5c6) at **15% opacity**. Never use 100% opaque borders.
*   **Glassmorphism Depth:** When using glass components, the `surface-tint` (#006571) should be applied as a 2% color overlay to the blurred background to ensure the "glass" feels like a physical lens.

---

## 5. Components

### Buttons
*   **Primary:** A vibrant gradient of `primary` to `primary-fixed-dim`. Roundedness: `xl` (3rem). Use `on-primary` (#d8f8ff) for text.
*   **Secondary:** `surface-container-highest` (#a1e7ff) with a "Ghost Border" of `outline`.
*   **Tertiary:** No background. Text in `tertiary` (#7000ff) with a subtle `3.5` (1.2rem) padding for a large hit area.

### Input Fields
*   **Structure:** No bottom line or full border. Use `surface-container-low` as a subtle recessed block with `ROUND_SIX` (xl: 3rem) corners.
*   **Focus State:** Transition the background to `surface-container-lowest` and add a soft glow using `primary-container`.

### Cards & Lists
*   **The "No Divider" Rule:** Forbid the use of divider lines. Separate list items using `spacing-2` (0.7rem) of vertical white space or alternating subtle background shifts between `surface-container-low` and `surface-container-lowest`.

### Progress Indicators (Neon Accents)
*   Use `secondary` (Cyber Purple) for tracks and `primary-fixed` (Electric Blue) for the active indicator. This high-contrast pairing creates the "Neon" signature against the soft light background.

---

## 6. Do’s and Don’ts

### Do:
*   **Do** embrace asymmetry. Offset your glass containers to create a sense of movement.
*   **Do** use the `xl` (3rem) corner radius for almost all container elements to maintain the "soft-futurism" vibe.
*   **Do** use `secondary` (#9500c8) sparingly as a "vibration" color for notifications or key highlights.

### Don’t:
*   **Don’t** use pure black (#000000) for text. Always use `on-surface` (#003440) to keep the palette harmonious.
*   **Don’t** stack glass on glass without increasing the blur radius of the top-most layer, or the hierarchy will collapse.
*   **Don’t** use small corner radii. If an element isn't rounded, it will feel like a "legacy" component and break the immersion.