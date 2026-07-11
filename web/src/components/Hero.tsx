import { useRef } from 'react';
import { motion, useScroll, useTransform, useSpring } from 'framer-motion';
import PhoneShell from './visuals/PhoneShell';
import ScanScreen from './visuals/ScanScreen';
import Leaf from './visuals/Leaf';
import MagneticButton from './MagneticButton';

const headlineWords = ['Snap.', 'Diagnose.', 'Grow.'];

export default function Hero() {
  const ref = useRef<HTMLElement>(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ['start start', 'end start'],
  });

  // parallax layers — move at different speeds
  const yBg = useTransform(scrollYProgress, [0, 1], ['0%', '40%']);
  const yMid = useTransform(scrollYProgress, [0, 1], ['0%', '25%']);
  const yPhone = useTransform(scrollYProgress, [0, 1], ['0%', '-18%']);
  const yText = useTransform(scrollYProgress, [0, 1], ['0%', '60%']);
  const opacity = useTransform(scrollYProgress, [0, 0.7], [1, 0]);
  const scalePhone = useTransform(scrollYProgress, [0, 1], [1, 0.92]);

  // phone 3D tilt based on pointer
  const tiltX = useSpring(0, { stiffness: 150, damping: 18 });
  const tiltY = useSpring(0, { stiffness: 150, damping: 18 });

  function handleTilt(e: React.MouseEvent<HTMLElement>) {
    const rect = e.currentTarget.getBoundingClientRect();
    const px = (e.clientX - rect.left) / rect.width - 0.5;
    const py = (e.clientY - rect.top) / rect.height - 0.5;
    tiltY.set(px * 18);
    tiltX.set(-py * 18);
  }
  function resetTilt() {
    tiltX.set(0);
    tiltY.set(0);
  }

  return (
    <section
      ref={ref}
      onMouseMove={handleTilt}
      onMouseLeave={resetTilt}
      className="relative flex min-h-[100svh] flex-col items-center justify-center overflow-hidden px-6 text-center"
    >
      {/* ---------- Background layers ---------- */}
      {/* deep gradient base */}
      <motion.div
        style={{ y: yBg }}
        className="absolute inset-0 bg-gradient-to-b from-krish-green via-krish-green to-krish-green-light"
      />
      {/* radial sunrise glow */}
      <div
        className="absolute left-1/2 top-[38%] -translate-x-1/2 -translate-y-1/2 w-[120vw] h-[120vw] max-w-[900px] max-h-[900px] rounded-full opacity-60"
        style={{
          background:
            'radial-gradient(circle, rgba(116,198,157,0.55) 0%, rgba(82,183,136,0.18) 35%, transparent 65%)',
        }}
      />
      {/* horizon hills — SVG silhouettes */}
      <motion.svg
        style={{ y: yMid }}
        viewBox="0 0 1440 400"
        preserveAspectRatio="none"
        className="absolute bottom-0 left-0 right-0 w-full h-[40%]"
        aria-hidden
      >
        <defs>
          <linearGradient id="hill1" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor="#40916C" />
            <stop offset="100%" stopColor="#2D6A4F" />
          </linearGradient>
          <linearGradient id="hill2" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor="#2D6A4F" />
            <stop offset="100%" stopColor="#1B4332" />
          </linearGradient>
        </defs>
        <path
          d="M0,260 C200,180 360,220 540,200 C760,176 920,240 1140,210 C1280,190 1380,210 1440,200 L1440,400 L0,400 Z"
          fill="url(#hill1)"
          opacity="0.9"
        />
        <path
          d="M0,320 C220,260 420,300 640,280 C880,258 1060,320 1280,300 C1360,292 1410,300 1440,300 L1440,400 L0,400 Z"
          fill="url(#hill2)"
        />
      </motion.svg>

      {/* floating leaves (parallax foreground) */}
      {[
        { top: '14%', left: '8%', size: 38, delay: 0, depth: 1.4 },
        { top: '22%', left: '82%', size: 30, delay: 1.2, depth: 1.1 },
        { top: '62%', left: '12%', size: 24, delay: 0.6, depth: 0.7 },
        { top: '70%', left: '88%', size: 44, delay: 2, depth: 0.9 },
        { top: '40%', left: '90%', size: 20, delay: 0.3, depth: 1.6 },
      ].map((l, i) => (
        <motion.div
          key={i}
          style={{
            y: useTransform(scrollYProgress, [0, 1], [0, -60 * l.depth]),
            top: l.top,
            left: l.left,
          }}
          className="absolute"
          aria-hidden
        >
          <Leaf size={l.size} color="#95d5b2" className="animate-drift" />
        </motion.div>
      ))}

      {/* ---------- Foreground content ---------- */}
      <motion.div
        style={{ y: yText, opacity }}
        className="relative z-20 flex flex-col items-center gap-7"
      >
        {/* tiny pill */}
        <motion.span
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2, type: 'spring', stiffness: 120, damping: 14 }}
          className="rounded-full border border-white/25 bg-white/10 px-4 py-1.5 text-[11px] font-semibold uppercase tracking-[0.2em] text-white/90 backdrop-blur-sm"
        >
          🌱 Offline AI for Every Field
        </motion.span>

        {/* Headline — word by word spring reveal */}
        <h1 className="font-display text-[14vw] font-black leading-[0.95] tracking-tight text-white sm:text-7xl md:text-8xl lg:text-[7.5rem]">
          {headlineWords.map((word, i) => (
            <motion.span
              key={word}
              initial={{ opacity: 0, y: 80, rotateX: -40 }}
              animate={{ opacity: 1, y: 0, rotateX: 0 }}
              transition={{
                delay: 0.4 + i * 0.18,
                type: 'spring',
                stiffness: 90,
                damping: 14,
              }}
              className={`mr-[0.18em] inline-block ${
                i === 2 ? 'text-shimmer' : ''
              }`}
              style={{ transformOrigin: 'bottom' }}
            >
              {word}
            </motion.span>
          ))}
        </h1>

        {/* Subhead */}
        <motion.p
          initial={{ opacity: 0, y: 24 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1.05, type: 'spring', stiffness: 80, damping: 16 }}
          className="max-w-xl text-base text-white/85 sm:text-lg md:text-xl"
        >
          AI-powered plant health reports, remedies &amp; community.
          <span className="mt-1 block font-semibold text-white">
            No internet required.
          </span>
        </motion.p>

        {/* CTAs */}
        <motion.div
          initial={{ opacity: 0, y: 24 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1.25, type: 'spring', stiffness: 80, damping: 16 }}
          className="flex flex-col items-center gap-3"
        >
          <MagneticButton
            href="#download"
            className="rounded-full bg-krish-green-lighter px-10 py-4 text-base font-bold text-white shadow-[0_12px_40px_-8px_rgba(82,183,136,0.7)] ring-1 ring-white/20 sm:text-lg"
          >
            <span className="flex items-center gap-2">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                <path d="M12 3v12m0 0l-4-4m4 4l4-4M5 21h14" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" />
              </svg>
              Download APK
            </span>
          </MagneticButton>
          <span className="text-xs text-white/60">
            Free · Android · Coming soon on iOS
          </span>
        </motion.div>
      </motion.div>

      {/* ---------- Floating phone (foreground, parallax) ---------- */}
      <motion.div
        style={{ y: yPhone, scale: scalePhone, opacity }}
        className="pointer-events-none absolute right-[6%] top-[8%] hidden lg:block"
        aria-hidden
      >
        {/* halo */}
        <div className="absolute -inset-10 animate-breathe blob bg-krish-green-glow/30 blur-2xl" />
        <motion.div
          style={{ rotateX: tiltX, rotateY: tiltY, transformPerspective: 1200 }}
          className="preserve-3d"
        >
          <PhoneShell scale={0.95} sheen>
            <ScanScreen />
          </PhoneShell>
        </motion.div>
      </motion.div>

      {/* ---------- Scroll cue ---------- */}
      <motion.div
        style={{ opacity }}
        className="absolute bottom-7 left-1/2 z-20 -translate-x-1/2"
        aria-hidden
      >
        <div className="flex h-9 w-5 items-start justify-center rounded-full border-2 border-white/40 p-1">
          <motion.div
            animate={{ y: [0, 10, 0] }}
            transition={{ duration: 1.6, repeat: Infinity, ease: 'easeInOut' }}
            className="h-1.5 w-1 rounded-full bg-white/70"
          />
        </div>
      </motion.div>

      {/* bottom fade into next section */}
      <div className="absolute bottom-0 left-0 right-0 z-10 h-24 bg-gradient-to-t from-krish-cream to-transparent" />
    </section>
  );
}
