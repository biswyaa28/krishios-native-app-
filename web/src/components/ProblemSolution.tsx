import { useRef } from 'react';
import { motion, useScroll, useTransform } from 'framer-motion';
import FarmerField from './visuals/FarmerField';
import PhoneShell from './visuals/PhoneShell';
import ResultScreen from './visuals/ResultScreen';

/**
 * Storytelling section: the worry (desaturated) is answered by the
 * vibrant, healthy scan result on the phone. As you scroll, the field
 * panel desaturates/darkens while the phone lifts and brightens —
 * visually carrying "problem → solution".
 */
export default function ProblemSolution() {
  const ref = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ['start end', 'end start'],
  });

  // field goes dull as it leaves; phone brightens & rises
  const fieldFilter = useTransform(
    scrollYProgress,
    [0, 0.5, 1],
    ['saturate(0.85) brightness(0.96)', 'saturate(0.55) brightness(0.82)', 'saturate(0.4) brightness(0.7)']
  );
  const phoneY = useTransform(scrollYProgress, [0, 0.5, 1], [60, 0, -40]);
  const phoneRotate = useTransform(scrollYProgress, [0, 1], [-8, 6]);
  const overlayOpacity = useTransform(scrollYProgress, [0, 1], [0, 0.55]);

  return (
    <section className="relative px-6 py-24 sm:py-32" ref={ref as any}>
      <div className="mx-auto max-w-6xl">
        {/* small kicker */}
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ type: 'spring', stiffness: 100, damping: 18 }}
          className="mb-3 text-center text-xs font-bold uppercase tracking-[0.25em] text-krish-brown"
        >
          The everyday worry
        </motion.p>

        <div className="grid items-center gap-10 md:grid-cols-2 md:gap-16">
          {/* ---------- Problem (field) ---------- */}
          <motion.div
            initial={{ opacity: 0, x: -60 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true, margin: '-80px' }}
            transition={{ type: 'spring', stiffness: 70, damping: 18 }}
            className="relative order-2 md:order-1"
          >
            <div className="relative mx-auto aspect-[3/4] w-full max-w-sm overflow-hidden rounded-[2rem] shadow-2xl">
              <motion.div style={{ filter: fieldFilter }} className="absolute inset-0">
                <FarmerField className="h-full w-full" />
              </motion.div>
              <motion.div
                style={{ opacity: overlayOpacity }}
                className="absolute inset-0 bg-gradient-to-t from-krish-soil/70 via-transparent to-krish-soil/20"
              />
              <div className="absolute bottom-5 left-5 right-5">
                <span className="inline-block rounded-full bg-krish-dark/60 px-3 py-1 text-[11px] font-semibold uppercase tracking-wider text-krish-cream backdrop-blur-sm">
                  Wilting crop · No expert nearby
                </span>
              </div>
            </div>
          </motion.div>

          {/* ---------- Solution (phone) ---------- */}
          <div className="relative order-1 flex justify-center md:order-2">
            {/* glow */}
            <div className="absolute left-1/2 top-1/2 h-[80%] w-[80%] -translate-x-1/2 -translate-y-1/2 animate-breathe rounded-full bg-krish-green-lighter/25 blur-3xl" />
            <motion.div
              style={{ y: phoneY, rotate: phoneRotate }}
              initial={{ opacity: 0, scale: 0.9 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true, margin: '-80px' }}
              transition={{ type: 'spring', stiffness: 80, damping: 16, delay: 0.15 }}
              className="relative z-10"
            >
              <PhoneShell scale={0.82}>
                <ResultScreen />
              </PhoneShell>
            </motion.div>

            {/* floating callout chips */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: 0.5, type: 'spring', stiffness: 100, damping: 14 }}
              className="absolute -left-2 top-6 hidden rounded-2xl bg-white px-3 py-2 text-xs font-bold text-krish-green shadow-xl sm:block"
            >
              ✓ 82% Healthy
            </motion.div>
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: 0.7, type: 'spring', stiffness: 100, damping: 14 }}
              className="absolute -right-2 bottom-10 hidden rounded-2xl bg-white px-3 py-2 text-xs font-bold text-krish-brown shadow-xl sm:block"
            >
              Treatment ready
            </motion.div>
          </div>
        </div>

        {/* ---------- The line ---------- */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ type: 'spring', stiffness: 90, damping: 16 }}
          className="mx-auto mt-16 max-w-2xl text-center"
        >
          <p className="font-display text-3xl font-extrabold leading-tight text-krish-dark sm:text-4xl md:text-5xl">
            Worried about your crop?
            <br />
            <span className="text-krish-green">Just take a photo.</span>
          </p>
          <p className="mx-auto mt-4 max-w-md text-base text-krish-dark/60">
            Point. Shoot. KrishiOS reads the leaves and gives you an instant
            diagnosis — even where there's no signal at all.
          </p>
        </motion.div>
      </div>
    </section>
  );
}
