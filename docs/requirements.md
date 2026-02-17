# Volcanic Terraformation

## Overview

Volcanic Terraformation provides a two-stage process for converting lava into buildable terrain:

1. **Volcanic Substrate** — hazardous suppression layer
2. **Structural Plating** — stabilized, buildable surface

Foundation (Aquilo) remains the superior late-game solution and can directly replace lava, bypassing both stages.

---

## Tiles

### Volcanic Substrate

**Purpose:** Suppress lava with a volatile, unstable crust. Not structurally sound.

**Placement Rules:**
- Can only be placed on lava
- Cannot be placed on any other terrain
- Cannot be stacked
- Converts lava → Volcanic Substrate

**Build Restrictions:**
- No entities allowed
- Only Structural Plating may be placed on top

**Risk:**
- **Manual placement:** Severe fire damage. Two rapid placements kill an unarmored player.
- **Robot placement:** Placing robot is destroyed by fire. Visual feedback (smoke/burn effect).

**Recipe:** 1 per craft
- 10 Concrete
- 4 Tungsten Plate
- 50 Water

**Visual Identity:** Glowing ember crust. Clearly unstable/hazardous.

**Description:** "Molten lava suppressed with tungsten-reinforced aggregate. Highly unstable. Not suitable for construction."

---

### Structural Plating

**Purpose:** Stabilizes Volcanic Substrate into engineered terrain suitable for heavy industry.

**Placement Rules:**
- Can only be placed on Volcanic Substrate
- Cannot be placed directly on lava
- Safe to place manually or by robots

**Build Permissions:**
- Fully buildable
- Behaves as standard solid ground

**Recipe:** 1 per craft
- 5 Scrap
- 10 Tungsten Carbide
- 2 Low Density Structure

**Visual Identity:** Dark industrial plating. Heavy reinforced aesthetic. Clear contrast from Substrate.

**Description:** "Tungsten-carbide reinforced structural platform. Stabilizes volcanic terrain for industrial use."

---

## Technology

### Volcanic Terraformation

**Unlocks:**
- Volcanic Substrate
- Structural Plating

**Prerequisites (Conceptual):**
- Tungsten carbide processing
- Scrap processing (Fulgora)
- Low Density Structure
- Interplanetary logistics
- Space science capability

**Science Packs Required:**
- Automation
- Logistic
- Chemical
- Production
- Utility
- Space
- Electromagnetic
- Metallurgic

**Research Cost:**
- 2000 units
- 30 seconds each

**Description:** "Industrial methods for stabilizing volcanic lava through staged substrate suppression and structural reinforcement."

---

## Progression Positioning

**Early Game (Vulcanus):**
- Lava remains restrictive

**Mid-Late Game:**
- Unlock terraforming at meaningful cost
- Substrate = hazardous suppression
- Plating = engineered expansion

**Late Game:**
- Foundation supersedes both stages
- Can directly replace lava without Substrate

---

## System Constraints

- Stage 2 always requires Stage 1
- Stage 1 is permanently non-buildable
- No automatic spreading or conversion
- Standard landfill cannot bypass the system
- Foundation can overwrite lava and both mod tiles

---

## Design Pillars

- Risk → Stabilization → Industrialization
- Planetary interdependence (Vulcanus + Fulgora)
- Medium cost, 1 tile per craft
- Used sparingly
- Bridges hazard phase to Foundation tier
