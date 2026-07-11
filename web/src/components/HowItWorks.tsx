import { useRef, type ReactNode } from 'react';
import { motion, useScroll, useTransform } from 'framer-motion';
import PhoneShell from './visuals/PhoneShell';
import ScanScreen from './visuals/ScanScreen';
import ResultScreen from './visuals/ResultScreen';
import RemedyScreen from './visuals/RemedyScreen';

const steps = [
  {
    n: '01',
    label: 'Click',
    blurb: 'Snap a photo of any leaf, fruit, or crop.',
    color: 'text-krish-brown',
    screen: <ScanScreen />,
  },
  {
    n: '02',
    label: 'Analyze',
    blurb: 'On-device AI diagnoses disease, pests & nutrients.',
    color: 'text-krish-green',
    screen: <ResultScreen />,
  },
  {
    n: '03',
    label: 'Act',
    blurb: 'Get step-by-step remedies and farmer tips.',
    color: 'text-krish-green-light',
    screen: <RemedyScreen />,
  },
];

export default function HowItWorks() {
  const ref = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ['start 0.8', 'end 0.5'],
  });
  // the dashed connector draws across as you scroll
  const dashOffset = useTransform(scrollYProgress, [0, 1], ['100%', '0%']);

  return (
    <section className="relative overflow-hidden px-6 py-24 sm:py-32">
      {/* soft bg wash */}
      <div className="pointer-events-none absolute inset-0 bg-gradient-to-b from-transparent via-krish-cream-deep/40 to-transparent" />

      <div className="relative mx-auto max-w-6xl" ref={ref}>
        {/* heading */}
        <div className="mb-16 text-center">
          <motion.p
            initial={{ opacity: 0, y: 16 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ type: 'spring', stiffness: 100, damping: 16 }}
            className="mb-3 text-xs font-bold uppercase tracking-[0.25em] text-krish-brown"
          >
            Three taps from worry to harvest
          </motion.p>
          <motion.h2
            initial={{ opacity: 0, y: 24 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ type: 'spring', stiffness: 80, damping: 16 }}
            className="font-display text-4xl font-extrabold text-krish-dark sm:text-5xl"
          >
            How It Works
          </motion.h2>
        </div>

        {/* phones */}
        <div className="relative grid items-start gap-12 sm:gap-6 md:grid-cols-3 md:gap-4">
          {/* dashed connector (desktop) */}
          <svg
            className="pointer-events-none absolute left-0 right-0 top-[34%] hidden h-2 w-full md:block"
            viewBox="0 0 100 2"
            preserveAspectRatio="none"
            aria-hidden
          >
            <motion.line
              x1="6"
              y1="1"
              x2="94"
              y2="1"
              stroke="#52B788"
              strokeWidth="0.5"
              strokeDasharray="1.2 1.2"
              style={{ strokeDashoffset: dashOffset as any }}
            />
          </svg>

          {steps.map((s, i) => (
            <StepCard key={s.n} index={i} step={s} />
          ))}
        </div>
      </div>
    </section>
  );
}

function StepCard({
  index,
  step,
}: {
  index: number;
  step: { n: string; label: string; blurb: string; color: string; screen: ReactNode };
}) {
  // alternate vertical offset for a playful cascade
  const offsets = [0, 28, 0];
  return (
    <motion.div
      initial={{ opacity: 0, y: 80, rotateZ: index === 1 ? 0 : index === 0 ? -3 : 3 }}
      whileInView={{ opacity: 1, y: offsets[index], rotateZ: 0 }}
      viewport={{ once: true, margin: '-60px' }}
      transition={{
        type: 'spring',
        stiffness: 70,
        damping: 14,
        delay: index * 0.18,
      }}
      className="flex flex-col items-center"
    >
      {/* number badge */}
      <div className="mb-5 flex items-center gap-2">
        <span className="font-display text-sm font-black text-krish-dark/20">{step.n}</span>
        <span className={`text-sm font-bold uppercase tracking-[0.2em] ${step.color}`}>
          {step.label}
        </span>
      </div>

      <div className="relative">
        {/* glow */}
        <div className="absolute -inset-6 -z-10 animate-breathe blob bg-krish-green-lighter/20 blur-2xl" />
        <PhoneShell scale={0.72} sheen>
          {step.screen}
        </PhoneShell>
      </div>

      <p className="mt-6 max-w-[15rem] text-center text-sm text-krish-dark/65">
        {step.blurb}
      </p>
    </motion.div>
  );
}
