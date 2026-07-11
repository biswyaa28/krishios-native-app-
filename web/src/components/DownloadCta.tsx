import { useRef } from 'react';
import { motion, useScroll, useTransform } from 'framer-motion';
import PhoneShell from './visuals/PhoneShell';
import ScanScreen from './visuals/ScanScreen';
import Leaf from './visuals/Leaf';
import MagneticButton from './MagneticButton';

/**
 * Final call-to-action. Full-width green gradient, a glowing phone,
 * a particle bloom of leaves, and the magnetic APK download button.
 */
export default function DownloadCta() {
  const ref = useRef<HTMLElement>(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ['start end', 'end center'],
  });
  const phoneY = useTransform(scrollYProgress, [0, 1], [80, 0]);
  const bloom = useTransform(scrollYProgress, [0, 1], [0.6, 1.2]);
  const bloomOpacity = useTransform(scrollYProgress, [0, 0.5, 1], [0, 0.6, 0.9]);

  // particle leaves scattered around the phone
  const particles = Array.from({ length: 14 }).map((_, i) => ({
    angle: (i / 14) * Math.PI * 2,
    radius: 120 + (i % 3) * 50,
    size: 16 + (i % 4) * 8,
    color: ['#95d5b2', '#74C69D', '#52B788', '#FEFAE0'][i % 4],
    delay: i * 0.08,
  }));

  return (
    <section
      id="download"
      ref={ref}
      className="relative flex min-h-[100svh] flex-col items-center justify-center overflow-hidden bg-gradient-to-b from-krish-green via-krish-green to-krish-green-light px-6 py-24 text-center text-white"
    >
      {/* sunrise glow */}
      <motion.div
        style={{ scale: bloom, opacity: bloomOpacity }}
        className="absolute left-1/2 top-1/2 h-[90vw] w-[90vw] max-w-[900px] max-h-[900px] -translate-x-1/2 -translate-y-1/2 rounded-full"
        aria-hidden
      >
        <div
          className="h-full w-full rounded-full"
          style={{
            background:
              'radial-gradient(circle, rgba(116,198,157,0.45) 0%, rgba(82,183,136,0.15) 40%, transparent 70%)',
          }}
        />
      </motion.div>

      {/* particle leaf bloom */}
      <motion.div
        style={{ scale: bloom, opacity: bloomOpacity }}
        className="pointer-events-none absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2"
        aria-hidden
      >
        {particles.map((p, i) => (
          <motion.span
            key={i}
            className="absolute"
            style={{
              transform: `translate(${Math.cos(p.angle) * p.radius}px, ${Math.sin(p.angle) * p.radius}px)`,
            }}
            animate={{ y: [0, -16, 0], rotate: [0, 30, 0] }}
            transition={{ duration: 4 + (i % 3), repeat: Infinity, ease: 'easeInOut', delay: p.delay }}
          >
            <Leaf size={p.size} color={p.color} />
          </motion.span>
        ))}
      </motion.div>

      {/* phone */}
      <motion.div
        style={{ y: phoneY }}
        initial={{ opacity: 0, scale: 0.85 }}
        whileInView={{ opacity: 1, scale: 1 }}
        viewport={{ once: true, margin: '-80px' }}
        transition={{ type: 'spring', stiffness: 70, damping: 15 }}
        className="relative z-10 mb-12"
      >
        <div className="absolute -inset-8 animate-breathe blob bg-krish-green-glow/40 blur-2xl" />
        <div className="relative">
          <PhoneShell scale={0.78} sheen>
            <ScanScreen />
          </PhoneShell>
        </div>
      </motion.div>

      {/* headline */}
      <motion.h2
        initial={{ opacity: 0, y: 30 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ type: 'spring', stiffness: 80, damping: 16 }}
        className="relative z-10 font-display text-5xl font-black tracking-tight sm:text-6xl md:text-7xl"
      >
        Start growing
        <br />
        <span className="text-shimmer">smarter.</span>
      </motion.h2>

      <motion.p
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ delay: 0.15, type: 'spring', stiffness: 80, damping: 16 }}
        className="relative z-10 mt-5 max-w-md text-base text-white/85 sm:text-lg"
      >
        Free for Android. Diagnose your first crop in under a minute — no
        account, no signal, no catch.
      </motion.p>

      {/* CTAs */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ delay: 0.3, type: 'spring', stiffness: 80, damping: 16 }}
        className="relative z-10 mt-9 flex flex-col items-center gap-3"
      >
        <MagneticButton
          href="/apk/krishios.apk"
          className="rounded-full bg-white px-12 py-5 text-lg font-bold text-krish-green shadow-2xl ring-1 ring-white/40"
        >
          <span className="flex items-center gap-2">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
              <path d="M12 3v12m0 0l-4-4m4 4l4-4M5 21h14" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" />
            </svg>
            Download APK
          </span>
        </MagneticButton>
        <span className="text-sm text-white/65">Coming soon on iOS · App Store badge at launch</span>
      </motion.div>

      {/* tiny wordmark */}
      <motion.p
        initial={{ opacity: 0 }}
        whileInView={{ opacity: 1 }}
        viewport={{ once: true }}
        transition={{ delay: 0.6 }}
        className="relative z-10 mt-16 flex items-center gap-2 text-xs font-semibold uppercase tracking-[0.3em] text-white/50"
      >
        <Leaf size={16} color="rgba(255,255,255,0.5)" />
        KrishiOS · krishi meets wisdom
      </motion.p>
    </section>
  );
}
