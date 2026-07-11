import { useRef } from 'react';
import { motion, useScroll, useTransform } from 'framer-motion';
import ScrollText from './ScrollText';
import Leaf from './visuals/Leaf';

/**
 * The cinematic brand-story moment. The manifesto reveals word-by-word
 * as you scroll through this tall section. Warm earthy gradient + drifting
 * leaves give depth. Krishi (cultivation) meets wisdom.
 */
export default function BrandStory() {
  const ref = useRef<HTMLElement>(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ['start start', 'end end'],
  });

  // parallax leaves drift upward as we scroll through
  const leafY1 = useTransform(scrollYProgress, [0, 1], [80, -120]);
  const leafY2 = useTransform(scrollYProgress, [0, 1], [120, -80]);
  const leafRot = useTransform(scrollYProgress, [0, 1], [-10, 30]);
  const glowScale = useTransform(scrollYProgress, [0, 0.5, 1], [0.8, 1.1, 0.9]);

  return (
    <section
      ref={ref}
      className="relative flex min-h-[140vh] items-center justify-center overflow-hidden bg-gradient-to-b from-krish-cream via-krish-cream-deep to-krish-brown/10"
    >
      {/* earthy radial warmth */}
      <motion.div
        style={{ scale: glowScale }}
        className="absolute left-1/2 top-1/2 h-[80vw] w-[80vw] max-w-[820px] max-h-[820px] -translate-x-1/2 -translate-y-1/2 rounded-full"
        aria-hidden
      >
        <div
          className="h-full w-full rounded-full"
          style={{
            background:
              'radial-gradient(circle, rgba(116,198,157,0.28) 0%, rgba(127,79,36,0.10) 45%, transparent 70%)',
          }}
        />
      </motion.div>

      {/* decorative drifting leaves */}
      <motion.div style={{ y: leafY1, rotate: leafRot }} className="absolute left-[8%] top-[18%]" aria-hidden>
        <Leaf size={56} color="#95d5b2" />
      </motion.div>
      <motion.div style={{ y: leafY2 }} className="absolute right-[10%] top-[26%]" aria-hidden>
        <Leaf size={42} color="#52B788" />
      </motion.div>
      <motion.div style={{ y: leafY2, rotate: leafRot }} className="absolute bottom-[16%] right-[18%]" aria-hidden>
        <Leaf size={34} color="#A47148" />
      </motion.div>
      <motion.div style={{ y: leafY1 }} className="absolute bottom-[22%] left-[16%]" aria-hidden>
        <Leaf size={28} color="#95d5b2" />
      </motion.div>

      {/* sticky center stage */}
      <div className="sticky top-1/2 z-10 -translate-y-1/2 px-6">
        <div className="mx-auto max-w-4xl text-center">
          {/* small mark */}
          <motion.div
            initial={{ opacity: 0, scale: 0.6 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true }}
            transition={{ type: 'spring', stiffness: 90, damping: 14 }}
            className="mx-auto mb-8 flex h-16 w-16 items-center justify-center rounded-2xl bg-krish-green text-white shadow-xl"
          >
            <Leaf size={34} color="#FEFAE0" />
          </motion.div>

          <ScrollText
            text='KrishiOS — where krishi (cultivation) meets wisdom. Built for the farmer who works the land, not the internet.'
            highlight={['krishi', 'wisdom.', 'land,', 'internet.']}
            highlightClassName="text-krish-green"
            className="font-display text-3xl font-bold leading-[1.35] tracking-tight text-krish-dark sm:text-4xl md:text-5xl md:leading-[1.3]"
            start="start 0.85"
            end="end 0.55"
          />

          <motion.p
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            transition={{ delay: 0.4 }}
            className="mt-10 text-sm font-semibold uppercase tracking-[0.3em] text-krish-brown/70"
          >
            krishi · संस्कृति · cultivation
          </motion.p>
        </div>
      </div>
    </section>
  );
}
