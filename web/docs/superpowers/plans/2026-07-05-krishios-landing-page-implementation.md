# KrishiOS Landing Page — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a marketing landing page for KrishiOS — a mobile app that diagnoses plant health offline.

**Architecture:** Single-page Astro site with Tailwind CSS styling and Framer Motion React islands for scroll-triggered spring animations. Zero backend. Static deploy.

**Tech Stack:** Astro 5, Tailwind CSS v4, Framer Motion, React 19

---

### Task 1: Scaffold Astro Project

**Files:**
- Create: `package.json`
- Create: `astro.config.mjs`
- Create: `tsconfig.json`
- Create: `tailwind.config.js` (if needed)
- Modify: (none)

- [ ] **Step 1: Create the Astro project**

Run in the working directory:

```bash
npm create astro@latest -- --template minimal --no-install --yes --skip-git .
```

- [ ] **Step 2: Install dependencies**

```bash
npm install
npm install @astrojs/react tailwindcss @tailwindcss/vite framer-motion @astrojs/tailwind @types/react @types/react-dom
```

- [ ] **Step 3: Configure Astro**

Write `astro.config.mjs`:

```js
import { defineConfig } from 'astro/config';
import react from '@astrojs/react';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  integrations: [react()],
  vite: {
    plugins: [tailwindcss()],
  },
  output: 'static',
});
```

- [ ] **Step 4: Configure TypeScript**

Write `tsconfig.json`:

```json
{
  "extends": "astro/tsconfigs/strict",
  "compilerOptions": {
    "jsx": "react-jsx",
    "jsxImportSource": "react"
  }
}
```

- [ ] **Step 5: Build once to verify scaffold**

```bash
npm run build
```

Expected: `astro build` completes with no errors, output in `dist/`.

- [ ] **Step 6: Commit**

```bash
git add -A && git commit -m "feat: scaffold Astro + Tailwind + Framer Motion"
```

---

### Task 2: Create Layout with Custom Design Tokens

**Files:**
- Create: `src/layouts/BaseLayout.astro`
- Create: `src/styles/global.css`
- Create: `public/images/.gitkeep`

- [ ] **Step 1: Write global CSS with custom properties**

Write `src/styles/global.css`:

```css
@import "tailwindcss";

@theme {
  --color-krish-green: #2D6A4F;
  --color-krish-green-light: #40916C;
  --color-krish-green-lighter: #52B788;
  --color-krish-brown: #7F4F24;
  --color-krish-cream: #FEFAE0;
  --color-krish-dark: #1B1B1B;
}

html {
  scroll-behavior: smooth;
}

body {
  @apply bg-krish-cream text-krish-dark font-sans;
}
```

- [ ] **Step 2: Write the base layout**

Write `src/layouts/BaseLayout.astro`:

```astro
---
import '../styles/global.css';

interface Props {
  title?: string;
  description?: string;
}

const { title = 'KrishiOS — Snap. Diagnose. Grow.', description = 'AI-powered plant health reports, remedies & community. No internet required.' } = Astro.props;
---

<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content={description} />
    <title>{title}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet" />
  </head>
  <body>
    <slot />
  </body>
</html>
```

- [ ] **Step 3: Create placeholder images directory**

```bash
mkdir -p public/images
touch public/images/.gitkeep
```

- [ ] **Step 4: Build to verify**

```bash
npm run build
```

Expected: Build succeeds.

- [ ] **Step 5: Commit**

```bash
git add -A && git commit -m "feat: add base layout with krishios design tokens"
```

---

### Task 3: AnimatedSection React Island Component

**Files:**
- Create: `src/components/AnimatedSection.tsx`

- [ ] **Step 1: Write AnimatedSection component**

Write `src/components/AnimatedSection.tsx`:

```tsx
import { motion } from 'framer-motion';
import type { ReactNode } from 'react';

interface Props {
  children: ReactNode;
  className?: string;
  delay?: number;
  direction?: 'up' | 'down' | 'left' | 'right' | 'none';
}

const directionOffset = {
  up: { y: 60 },
  down: { y: -60 },
  left: { x: 60 },
  right: { x: -60 },
  none: {},
};

export default function AnimatedSection({ children, className, delay = 0, direction = 'up' }: Props) {
  return (
    <motion.section
      className={className}
      initial={{ opacity: 0, ...directionOffset[direction] }}
      whileInView={{ opacity: 1, x: 0, y: 0 }}
      viewport={{ once: true, margin: '-100px' }}
      transition={{
        type: 'spring',
        stiffness: 80,
        damping: 20,
        delay,
      }}
    >
      {children}
    </motion.section>
  );
}
```

- [ ] **Step 2: Build to verify**

```bash
npm run build
```

Expected: Build succeeds, no type errors.

- [ ] **Step 3: Commit**

```bash
git add -A && git commit -m "feat: add AnimatedSection React island with spring animations"
```

---

### Task 4: Hero Section

**Files:**
- Create: `src/components/Hero.astro`

- [ ] **Step 1: Write Hero component**

Write `src/components/Hero.astro`:

```astro
---
import AnimatedSection from './AnimatedSection';
---

<AnimatedSection direction="none" class="relative flex min-h-screen flex-col items-center justify-center bg-gradient-to-b from-krish-green to-krish-green-light px-6 text-center text-white overflow-hidden">
  <div class="absolute inset-0 opacity-10 bg-[url('/images/field-bg.jpg')] bg-cover bg-center" />
  <div class="relative z-10 flex flex-col items-center gap-8">
    <div class="w-64 h-128 rounded-3xl shadow-2xl bg-krish-dark/20 backdrop-blur-sm border-4 border-white/20 flex items-center justify-center">
      <img src="/images/phone-mockup-hero.png" alt="KrishiOS app scan screen" class="w-full h-full object-contain rounded-2xl" />
    </div>
    <h1 class="text-5xl md:text-7xl font-extrabold leading-tight tracking-tight">
      Snap. Diagnose. Grow.
    </h1>
    <p class="max-w-xl text-lg md:text-xl text-white/80">
      KrishiOS — AI-powered plant health reports, remedies &amp; community.
      <span class="block mt-1 font-semibold text-white">No internet required.</span>
    </p>
    <div class="flex flex-col items-center gap-3">
      <a
        href="/apk/krishios.apk"
        download
        class="rounded-full bg-krish-green-lighter px-10 py-4 text-lg font-bold text-white shadow-lg transition-transform hover:scale-105 active:scale-95"
      >
        Download APK
      </a>
      <span class="text-sm text-white/60">Coming soon on iOS</span>
    </div>
  </div>
</AnimatedSection>
```

- [ ] **Step 2: Build to verify**

```bash
npm run build
```

Expected: Build succeeds.

- [ ] **Step 3: Commit**

```bash
git add -A && git commit -m "feat: add hero section with CTA buttons"
```

---

### Task 5: Problem → Solution Section

**Files:**
- Create: `src/components/ProblemSolution.astro`

- [ ] **Step 1: Write ProblemSolution component**

Write `src/components/ProblemSolution.astro`:

```astro
---
import AnimatedSection from './AnimatedSection';
---

<AnimatedSection class="flex flex-col items-center gap-8 px-6 py-24 max-w-5xl mx-auto">
  <div class="flex flex-col md:flex-row items-center justify-center gap-8 md:gap-16">
    <div class="w-60 h-80 md:w-72 md:h-96 rounded-2xl overflow-hidden shadow-xl bg-krish-brown/10">
      <img src="/images/farmer-worried.jpg" alt="Farmer inspecting crop" class="w-full h-full object-cover" />
    </div>
    <div class="w-60 h-80 md:w-72 md:h-96 rounded-2xl overflow-hidden shadow-xl bg-krish-green/10 md:translate-y-12">
      <img src="/images/phone-scan-result.png" alt="KrishiOS health report" class="w-full h-full object-cover" />
    </div>
  </div>
  <p class="text-center text-xl md:text-2xl font-bold text-krish-dark bg-white/80 px-8 py-4 rounded-full shadow-md">
    Worried about your crop?<br />Just take a photo.
  </p>
</AnimatedSection>
```

- [ ] **Step 2: Build to verify**

```bash
npm run build
```

Expected: Build succeeds.

- [ ] **Step 3: Commit**

```bash
git add -A && git commit -m "feat: add problem solution section with side-by-side images"
```

---

### Task 6: How It Works Section

**Files:**
- Create: `src/components/HowItWorks.tsx`
- Create: `src/components/HowItWorks.astro`

- [ ] **Step 1: Write the HowItWorks React island**

Write `src/components/HowItWorks.tsx`:

```tsx
import { motion } from 'framer-motion';

const steps = [
  { label: 'Click', image: '/images/step-click.png', alt: 'Snap a photo of your plant' },
  { label: 'Analyze', image: '/images/step-analyze.png', alt: 'AI analyzes the crop health' },
  { label: 'Act', image: '/images/step-act.png', alt: 'Get remedies and tips' },
];

const containerVariants = {
  hidden: {},
  visible: {
    transition: { staggerChildren: 0.25 },
  },
};

const cardVariants = {
  hidden: { opacity: 0, y: 50 },
  visible: {
    opacity: 1,
    y: 0,
    transition: { type: 'spring', stiffness: 100, damping: 15 },
  },
};

export default function HowItWorks() {
  return (
    <section className="px-6 py-24 max-w-5xl mx-auto text-center">
      <h2 className="text-3xl md:text-4xl font-bold text-krish-dark mb-16">How It Works</h2>
      <motion.div
        className="flex flex-col md:flex-row items-center justify-center gap-8 md:gap-12"
        variants={containerVariants}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true, margin: '-50px' }}
      >
        {steps.map((step) => (
          <motion.div key={step.label} className="flex flex-col items-center gap-4" variants={cardVariants}>
            <div className="w-48 h-96 rounded-2xl shadow-lg bg-white overflow-hidden">
              <img src={step.image} alt={step.alt} className="w-full h-full object-cover" />
            </div>
            <span className="text-lg font-semibold text-krish-brown uppercase tracking-wider">{step.label}</span>
          </motion.div>
        ))}
      </motion.div>
    </section>
  );
}
```

- [ ] **Step 2: Write the Astro wrapper**

Write `src/components/HowItWorks.astro`:

```astro
---
import HowItWorks from './HowItWorks';
---

<HowItWorks client:load />
```

- [ ] **Step 3: Build to verify**

```bash
npm run build
```

Expected: Build succeeds.

- [ ] **Step 4: Commit**

```bash
git add -A && git commit -m "feat: add how it works section with staggered spring animations"
```

---

### Task 7: Features Grid Section

**Files:**
- Create: `src/components/FeaturesGrid.astro`

- [ ] **Step 1: Write FeaturesGrid component**

Write `src/components/FeaturesGrid.astro`:

```astro
---
import AnimatedSection from './AnimatedSection';

const features = [
  { icon: '🧠', title: 'Offline AI', desc: 'Works in remote fields' },
  { icon: '🌿', title: 'Health Reports', desc: 'Disease, pests, nutrients' },
  { icon: '🔧', title: 'Remedies', desc: 'Step-by-step treatment' },
  { icon: '👥', title: 'Community', desc: 'Connect with farmers' },
];
---

<AnimatedSection class="px-6 py-24 max-w-5xl mx-auto">
  <div class="grid grid-cols-2 gap-6 md:gap-10">
    {features.map((f, i) => (
      <div
        class="flex flex-col items-center text-center gap-3 rounded-2xl bg-white p-8 shadow-md transition-transform hover:scale-105 hover:shadow-xl"
      >
        <span class="text-4xl">{f.icon}</span>
        <h3 class="text-xl font-bold text-krish-green">{f.title}</h3>
        <p class="text-krish-dark/70">{f.desc}</p>
      </div>
    ))}
  </div>
</AnimatedSection>
```

- [ ] **Step 2: Build to verify**

```bash
npm run build
```

Expected: Build succeeds.

- [ ] **Step 3: Commit**

```bash
git add -A && git commit -m "feat: add features grid section"
```

---

### Task 8: Brand Story Section

**Files:**
- Create: `src/components/BrandStory.tsx`
- Create: `src/components/BrandStory.astro`

- [ ] **Step 1: Write BrandStory React island**

Write `src/components/BrandStory.tsx`:

```tsx
import { motion } from 'framer-motion';

export default function BrandStory() {
  return (
    <section className="relative flex items-center justify-center px-6 py-32 bg-gradient-to-b from-krish-brown/10 to-krish-cream overflow-hidden">
      <div className="absolute inset-0 opacity-5 bg-[url('/images/leaf-texture.png')] bg-repeat" />
      <motion.p
        className="relative z-10 max-w-3xl text-center text-2xl md:text-3xl font-semibold text-krish-brown leading-relaxed italic"
        initial={{ opacity: 0, scale: 0.9 }}
        whileInView={{ opacity: 1, scale: 1 }}
        viewport={{ once: true }}
        transition={{ type: 'spring', stiffness: 60, damping: 15, delay: 0.1 }}
      >
        "KrishiOS — where krishi (cultivation) meets wisdom. Built for the farmer who works the land, not the internet."
      </motion.p>
    </section>
  );
}
```

- [ ] **Step 2: Write the Astro wrapper**

Write `src/components/BrandStory.astro`:

```astro
---
import BrandStory from './BrandStory';
---

<BrandStory client:load />
```

- [ ] **Step 3: Build to verify**

```bash
npm run build
```

Expected: Build succeeds.

- [ ] **Step 4: Commit**

```bash
git add -A && git commit -m "feat: add brand story section with fade-scale animation"
```

---

### Task 9: Community Preview Section

**Files:**
- Create: `src/components/CommunityPreview.astro`

- [ ] **Step 1: Write CommunityPreview component**

Write `src/components/CommunityPreview.astro`:

```astro
---
import AnimatedSection from './AnimatedSection';
---

<AnimatedSection class="flex flex-col items-center gap-8 px-6 py-24 max-w-4xl mx-auto text-center">
  <div class="w-72 md:w-96 rounded-3xl shadow-xl overflow-hidden bg-white">
    <img src="/images/community-feed.png" alt="KrishiOS community feed" class="w-full h-full object-cover" />
  </div>
  <p class="text-2xl md:text-3xl font-bold text-krish-green">
    1,000+ farmers growing smarter together.
  </p>
</AnimatedSection>
```

- [ ] **Step 2: Build to verify**

```bash
npm run build
```

Expected: Build succeeds.

- [ ] **Step 3: Commit**

```bash
git add -A && git commit -m "feat: add community preview section"
```

---

### Task 10: Download CTA Footer Section

**Files:**
- Create: `src/components/DownloadCta.astro`

- [ ] **Step 1: Write DownloadCta component**

Write `src/components/DownloadCta.astro`:

```astro
---
import AnimatedSection from './AnimatedSection';
---

<AnimatedSection direction="up" class="flex flex-col items-center gap-8 px-6 py-24 bg-gradient-to-b from-krish-green to-krish-green-light text-white text-center">
  <div class="w-56 h-112 rounded-3xl shadow-2xl bg-white/10 backdrop-blur-sm border-4 border-white/20 overflow-hidden">
    <img src="/images/phone-mockup-cta.png" alt="KrishiOS app" class="w-full h-full object-contain" />
  </div>
  <h2 class="text-4xl md:text-5xl font-extrabold">Start growing smarter.</h2>
  <a
    href="/apk/krishios.apk"
    download
    class="rounded-full bg-white px-10 py-4 text-lg font-bold text-krish-green shadow-lg transition-transform hover:scale-105 active:scale-95"
  >
    Download APK
  </a>
  <span class="text-sm text-white/60">Coming soon on iOS</span>
</AnimatedSection>
```

- [ ] **Step 2: Build to verify**

```bash
npm run build
```

Expected: Build succeeds.

- [ ] **Step 3: Commit**

```bash
git add -A && git commit -m "feat: add download CTA footer section"
```

---

### Task 11: Compose Main Page

**Files:**
- Create: `src/pages/index.astro`
- Modify: (none)

- [ ] **Step 1: Write the main index page**

Write `src/pages/index.astro`:

```astro
---
import BaseLayout from '../layouts/BaseLayout.astro';
import Hero from '../components/Hero.astro';
import ProblemSolution from '../components/ProblemSolution.astro';
import HowItWorks from '../components/HowItWorks.astro';
import FeaturesGrid from '../components/FeaturesGrid.astro';
import BrandStory from '../components/BrandStory.astro';
import CommunityPreview from '../components/CommunityPreview.astro';
import DownloadCta from '../components/DownloadCta.astro';
---

<BaseLayout>
  <Hero />
  <ProblemSolution />
  <HowItWorks />
  <FeaturesGrid />
  <BrandStory />
  <CommunityPreview />
  <DownloadCta />
</BaseLayout>
```

- [ ] **Step 2: Build to verify everything composes**

```bash
npm run build
```

Expected: Build succeeds, `dist/` contains the output.

- [ ] **Step 3: Commit**

```bash
git add -A && git commit -m "feat: compose all sections into main landing page"
```

---

### Task 12: Final Polish & Edge Cases

**Files:**
- Modify: `src/pages/index.astro` (add viewport meta, lang attributes already in layout)
- Create: (none)

- [ ] **Step 1: Verify responsive breakpoints**

```bash
npm run build
```

Then inspect that the site looks good at 375px, 768px, and 1440px widths.

- [ ] **Step 2: Handle image fallbacks**

Add `onerror` fallback to images or ensure placeholder images are present. For now, verify all image paths in `public/images/` exist, or add `onerror` to hide broken images.

- [ ] **Step 3: Verify APK download path**

Ensure `public/apk/krishios.apk` exists or create the directory with a placeholder. The build won't fail without it, but the download link should be functional.

```bash
mkdir -p public/apk
```

- [ ] **Step 4: Final build**

```bash
npm run build && ls -la dist/
```

Expected: `dist/index.html` exists, no JS errors in build output.

- [ ] **Step 5: Commit**

```bash
git add -A && git commit -m "chore: final polish and edge case handling"
```
