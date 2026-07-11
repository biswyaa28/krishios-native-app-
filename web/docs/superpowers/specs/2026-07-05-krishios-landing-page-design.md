# KrishiOS Landing Page — Design Spec

**Date:** 2026-07-05
**Status:** Draft

---

## Overview

Marketing landing page for **KrishiOS**, a Flutter mobile app that lets farmers and gardeners take/upload a photo of their plant or crop and receive an AI-powered health report, remedies, and tips — all fully offline. The app also includes a community section to connect with other farmers.

## Design Approach

**Approach 3: Product-Hero Heavy** — Minimal text, maximum visual impact. Each section relies on a hero photo or phone mockup with a single line of text. Physics-based spring animations throughout.

## Audience

- **Primary:** Smallholder farmers in rural/remote areas (limited internet)
- **Secondary:** Home gardeners and hobbyists
- Tone: **Warm, rustic, earthy**

## Color Palette & Typography

| Token | Value |
|-------|-------|
| Primary green | `#2D6A4F` (deep foliage) |
| Secondary green | `#40916C` |
| Warm brown | `#7F4F24` |
| Cream background | `#FEFAE0` |
| Dark text | `#1B1B1B` |
| Accent/CTA | `#52B788` |

- **Headline font:** Bold display, sturdy feel (e.g., Inter Bold or similar)
- **Body font:** Clean readable sans-serif

## Animations

All scroll-triggered physics-based spring animations:
- Parallax scrolling on hero background
- Spring bounce + stagger on "How It Works" cards
- Lift/rotate on phone mockups
- Fade + scale spring on brand story text

## Page Sections (Top to Bottom)

### 1. Hero

- Full-viewport section with a field/crop background photo
- Phone mockup floating prominently (angled, screen showing crop scan UI)
- **Headline:** *"Snap. Diagnose. Grow."*
- **Subheadline:** *"KrishiOS — AI-powered plant health reports, remedies & community. No internet required."*
- **CTAs:** [APK Download] button (green, primary) + "Coming soon on iOS" (smaller text link)
- No navigation menu

### 2. Problem → Solution

- Left side: emotive photo of a farmer looking at a wilting crop
- Right side: phone mockup showing scan result (healthy plant)
- **Text overlay:** *"Worried about your crop? Just take a photo."*
- Phone mockup animates in with a lift + rotate spring

### 3. How It Works

- Three horizontally laid-out phone screenshots with short labels:

| Step | Label |
|------|-------|
| Snap a photo (camera UI) | *Click* |
| AI diagnoses instantly (result screen) | *Analyze* |
| Get remedies + community tips (chat screen) | *Act* |

- Staggered spring bounce animation on scroll

### 4. Key Features (2×2 Grid)

| Card | Icon | Text |
|------|------|------|
| Offline AI | Chip/brain | *"Works in remote fields"* |
| Health Reports | Leaf | *"Disease, pests, nutrients"* |
| Remedies | Tool/wrench | *"Step-by-step treatment"* |
| Community | People | *"Connect with farmers"* |

- Subtle parallax on hover/scroll

### 5. Brand Story

- Full-width earthy background (warm green/tan, subtle leaf texture)
- Single centered sentence:
  > *"KrishiOS — where krishi (cultivation) meets wisdom. Built for the farmer who works the land, not the internet."*
- Slow fade + scale spring animation

### 6. Community Preview

- Single screenshot of the community feed (farmers talking, crop photos)
- **Overlay line:** *"1,000+ farmers growing smarter together."*

### 7. Download CTA (Footer)

- Full-width green background
- **Bold line:** *"Start growing smarter."*
- Big phone mockup showing the app
- **CTAs:** [APK Download] button + *"Coming soon on iOS"* text
- No footer navigation, no extraneous links

## Download Strategy

| Platform | Method |
|----------|--------|
| Android | Direct APK download from the page |
| iOS | "Coming soon on iOS" placeholder text + App Store badge (added when published) |

## Assumptions & Prerequisites

- **App screenshots** with real UI content will be provided by the product owner for phone mockups (scan screen, chat screen, community feed)
- APK file will be hosted alongside the landing page or linked via a direct URL
- No analytics, forms, or backend are needed at launch

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | **Astro** (static output, zero JS by default) |
| Styling | **Tailwind CSS** |
| Animations | **Framer Motion** (via React islands in Astro) |
| Responsiveness | Mobile-first (critical for rural users on phones) |
| Hosting | Static — deployable to any static host |

- Fully responsive (mobile-first since audience may view on phones)
- No backend required — purely static landing page
