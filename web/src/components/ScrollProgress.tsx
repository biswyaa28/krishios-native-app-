import { motion, useScroll, useSpring } from 'framer-motion';

/** A thin spring-smoothed progress bar pinned to the top of the viewport. */
export default function ScrollProgress() {
  const { scrollYProgress } = useScroll();
  const scaleX = useSpring(scrollYProgress, {
    stiffness: 120,
    damping: 30,
    restDelta: 0.001,
  });

  return (
    <motion.div
      style={{ scaleX }}
      className="fixed top-0 left-0 right-0 z-[70] h-[3px] origin-left bg-gradient-to-r from-krish-green-lighter via-krish-green-glow to-krish-green"
      aria-hidden
    />
  );
}
