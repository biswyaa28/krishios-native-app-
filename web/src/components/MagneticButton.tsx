import { useRef, type ReactNode } from 'react';
import { motion, useMotionValue, useSpring, useTransform } from 'framer-motion';

interface MagneticButtonProps {
  children: ReactNode;
  href: string;
  className?: string;
  strength?: number;
}

/**
 * A button that subtly attracts toward the cursor (magnetic effect)
 * with a radial light glow that follows the pointer.
 */
export default function MagneticButton({
  children,
  href,
  className = '',
  strength = 0.35,
}: MagneticButtonProps) {
  const ref = useRef<HTMLAnchorElement>(null);
  const mx = useMotionValue(50);
  const my = useMotionValue(50);

  const x = useMotionValue(0);
  const y = useMotionValue(0);
  const sx = useSpring(x, { stiffness: 200, damping: 15 });
  const sy = useSpring(y, { stiffness: 200, damping: 15 });

  function handleMove(e: React.MouseEvent<HTMLAnchorElement>) {
    const el = ref.current;
    if (!el) return;
    const rect = el.getBoundingClientRect();
    const relX = e.clientX - rect.left;
    const relY = e.clientY - rect.top;
    x.set((relX - rect.width / 2) * strength);
    y.set((relY - rect.height / 2) * strength);
    mx.set((relX / rect.width) * 100);
    my.set((relY / rect.height) * 100);
  }

  function handleLeave() {
    x.set(0);
    y.set(0);
  }

  return (
    <motion.a
      ref={ref}
      href={href}
      onMouseMove={handleMove}
      onMouseLeave={handleLeave}
      style={{ x: sx, y: sy, ['--mx' as string]: useTransform(mx, (v) => `${v}%`), ['--my' as string]: useTransform(my, (v) => `${v}%`) }}
      whileTap={{ scale: 0.95 }}
      className={`btn-magnetic inline-flex items-center justify-center ${className}`}
    >
      {children}
    </motion.a>
  );
}
