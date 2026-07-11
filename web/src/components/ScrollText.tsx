import { useRef } from 'react';
import { motion, useScroll, useTransform } from 'framer-motion';

interface ScrollTextProps {
  text: string;
  className?: string;
  /** highlight these words with the accent color */
  highlight?: string[];
  highlightClassName?: string;
  /** start/end offset of scroll range across the element */
  start?: string;
  end?: string;
}

/**
 * Reveals each word from dim/raised to bright/settled as the user scrolls.
 * Used for the brand-story manifesto to feel like a cinematic reveal.
 */
export default function ScrollText({
  text,
  className = '',
  highlight = [],
  highlightClassName = 'text-krish-green-lighter',
  start = 'start 0.9',
  end = 'end 0.4',
}: ScrollTextProps) {
  const ref = useRef<HTMLParagraphElement>(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: [start as any, end as any],
  });

  const words = text.split(' ');

  return (
    <p ref={ref} className={className}>
      {words.map((w, i) => {
        const clean = w.replace(/[.,——"']/g, '').toLowerCase();
        const isHi = highlight.includes(clean);
        const startAt = i / words.length;
        const endAt = startAt + 1 / words.length;
        return (
          <Word
            key={i}
            progress={scrollYProgress}
            range={[startAt, endAt]}
            highlight={isHi ? highlightClassName : ''}
          >
            {w}
          </Word>
        );
      })}
    </p>
  );
}

function Word({
  children,
  progress,
  range,
  highlight,
}: {
  children: string;
  progress: any;
  range: [number, number];
  highlight: string;
}) {
  const opacity = useTransform(progress, range, [0.12, 1]);
  const y = useTransform(progress, range, [8, 0]);
  return (
    <span className="inline-block overflow-hidden align-bottom">
      <motion.span
        style={{ opacity, y }}
        className={`inline-block ${highlight}`}
      >
        {children}&nbsp;
      </motion.span>
    </span>
  );
}
