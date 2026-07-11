import { useRef } from 'react';
import { motion, useScroll, useTransform } from 'framer-motion';
import PhoneShell from './visuals/PhoneShell';
import CommunityScreen from './visuals/CommunityScreen';
import Leaf from './visuals/Leaf';

const floatingFarmers = [
  { initials: 'R', color: 'bg-krish-amber', top: '8%', left: '6%', delay: 0 },
  { initials: 'L', color: 'bg-krish-green-light', top: '20%', left: '88%', delay: 0.4 },
  { initials: 'A', color: 'bg-krish-brown-light', top: '68%', left: '4%', delay: 0.8 },
  { initials: 'F', color: 'bg-krish-green', top: '76%', left: '90%', delay: 0.2 },
  { initials: 'S', color: 'bg-krish-green-lighter', top: '44%', left: '92%', delay: 0.6 },
];

export default function CommunityPreview() {
  const ref = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ['start end', 'end start'],
  });
  const phoneY = useTransform(scrollYProgress, [0, 1], [60, -60]);
  const phoneRotate = useTransform(scrollYProgress, [0, 1], [-4, 4]);

  return (
    <section className="relative overflow-hidden px-6 py-24 sm:py-32">
      <div className="mx-auto max-w-5xl" ref={ref}>
        <div className="mb-14 text-center">
          <motion.p
            initial={{ opacity: 0, y: 16 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ type: 'spring', stiffness: 100, damping: 16 }}
            className="mb-3 text-xs font-bold uppercase tracking-[0.25em] text-krish-brown"
          >
            You're not farming alone
          </motion.p>
          <motion.h2
            initial={{ opacity: 0, y: 24 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ type: 'spring', stiffness: 80, damping: 16 }}
            className="font-display text-4xl font-extrabold text-krish-dark sm:text-5xl"
          >
            A whole village in your pocket.
          </motion.h2>
        </div>

        <div className="relative flex justify-center">
          {/* floating avatars (parallax) */}
          {floatingFarmers.map((f, i) => (
            <motion.div
              key={i}
              style={{
                top: f.top,
                left: f.left,
                y: useTransform(scrollYProgress, [0, 1], [40 - i * 8, -40 + i * 8]),
              }}
              initial={{ opacity: 0, scale: 0 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true }}
              transition={{ delay: f.delay, type: 'spring', stiffness: 200, damping: 14 }}
              className="absolute z-20 hidden sm:block"
            >
              <div
                className={`flex h-12 w-12 items-center justify-center rounded-full ${f.color} text-sm font-bold text-white shadow-xl ring-4 ring-white`}
              >
                {f.initials}
              </div>
            </motion.div>
          ))}

          {/* glow */}
          <div className="absolute left-1/2 top-1/2 h-[70%] w-[60%] -translate-x-1/2 -translate-y-1/2 animate-breathe rounded-full bg-krish-green-lighter/20 blur-3xl" />

          <motion.div
            style={{ y: phoneY, rotate: phoneRotate }}
            initial={{ opacity: 0, scale: 0.9 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true, margin: '-80px' }}
            transition={{ type: 'spring', stiffness: 80, damping: 16 }}
            className="relative z-10"
          >
            <PhoneShell scale={0.92}>
              <CommunityScreen />
            </PhoneShell>
          </motion.div>

          {/* decorative leaf */}
          <motion.div
            style={{ rotate: useTransform(scrollYProgress, [0, 1], [-20, 40]) }}
            className="absolute -bottom-4 left-[12%] hidden sm:block"
            aria-hidden
          >
            <Leaf size={40} color="#95d5b2" />
          </motion.div>
        </div>

        <motion.p
          initial={{ opacity: 0, y: 24 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ type: 'spring', stiffness: 80, damping: 16 }}
          className="mx-auto mt-14 max-w-xl text-center font-display text-2xl font-extrabold text-krish-green sm:text-3xl"
        >
          1,000+ farmers growing smarter, together.
        </motion.p>
        <p className="mx-auto mt-3 max-w-md text-center text-base text-krish-dark/60">
          Share a photo, get a second opinion, trade remedies — a network that
          grows as fast as your fields.
        </p>
      </div>
    </section>
  );
}
