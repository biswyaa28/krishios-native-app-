import { motion } from 'framer-motion';

/**
 * Line icons whose strokes "draw" themselves when scrolled into view.
 * Each returns a motion.svg with a consistent draw-in transition.
 */

const drawTransition = {
  pathLength: { duration: 1.4, ease: 'easeInOut' },
  opacity: { duration: 0.3, ease: 'easeInOut' },
};

function DrawPath({
  d,
  delay = 0,
  variants,
}: {
  d: string;
  delay?: number;
  variants: any;
}) {
  return (
    <motion.path
      d={d}
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      variants={variants}
      transition={{ ...drawTransition, delay }}
    />
  );
}

function IconShell({ children }: { children: React.ReactNode }) {
  const variants = {
    hidden: { pathLength: 0, opacity: 0 },
    visible: (i: number = 1) => ({
      pathLength: 1,
      opacity: 1,
      transition: { staggerChildren: 0.08, delayChildren: i * 0.05 },
    }),
  };
  return (
    <motion.svg
      viewBox="0 0 48 48"
      className="h-10 w-10"
      initial="hidden"
      whileInView="visible"
      viewport={{ once: true, margin: '-40px' }}
    >
      {children(variants)}
    </motion.svg>
  );
}

export function OfflineAIIcon() {
  return (
    <IconShell>
      {(variants: any) => (
        <>
          {/* brain/chip body */}
          <DrawPath d="M24 10c5 4 8 7 8 12a8 8 0 0 1-16 0c0-5 3-8 8-12z" variants={variants} />
          <DrawPath d="M24 14v18M18 20h12M19 26h10" variants={variants} delay={0.2} />
          {/* offline slash */}
          <DrawPath d="M12 36l24-24" variants={variants} delay={0.4} />
        </>
      )}
    </IconShell>
  );
}

export function HealthReportIcon() {
  return (
    <IconShell>
      {(variants: any) => (
        <>
          <DrawPath d="M24 8c6 5 10 9 10 15a10 10 0 0 1-20 0c0-6 4-10 10-15z" variants={variants} />
          <DrawPath d="M20 24l3 3 6-7" variants={variants} delay={0.3} />
          <DrawPath d="M24 8v-2" variants={variants} delay={0.5} />
        </>
      )}
    </IconShell>
  );
}

export function RemediesIcon() {
  return (
    <IconShell>
      {(variants: any) => (
        <>
          {/* wrench */}
          <DrawPath d="M30 10a6 6 0 0 0-7 8l-13 13 4 4 13-13a6 6 0 0 0 8-7l-4 4-4-1-1-4 4-4z" variants={variants} />
          <DrawPath d="M14 34l-4 4" variants={variants} delay={0.3} />
        </>
      )}
    </IconShell>
  );
}

export function CommunityIcon() {
  return (
    <IconShell>
      {(variants: any) => (
        <>
          <DrawPath d="M16 22a6 6 0 1 0 0-12 6 6 0 0 0 0 12z" variants={variants} />
          <DrawPath d="M32 22a6 6 0 1 0 0-12 6 6 0 0 0 0 12z" variants={variants} delay={0.1} />
          <DrawPath d="M6 40c0-5 4-9 10-9s10 4 10 9" variants={variants} delay={0.2} />
          <DrawPath d="M22 40c0-5 4-9 10-9s10 4 10 9" variants={variants} delay={0.3} />
        </>
      )}
    </IconShell>
  );
}

export const icons = {
  offline: OfflineAIIcon,
  health: HealthReportIcon,
  remedies: RemediesIcon,
  community: CommunityIcon,
};
