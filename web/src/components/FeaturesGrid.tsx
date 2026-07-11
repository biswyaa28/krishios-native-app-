import { motion } from 'framer-motion';
import { icons } from './visuals/FeatureIcons';

const features = [
  {
    key: 'offline' as const,
    title: 'Offline AI',
    desc: 'Runs entirely on-device — works in the most remote fields, no signal needed.',
    accent: 'from-krish-green to-krish-green-light',
    stat: '0 MB data',
  },
  {
    key: 'health' as const,
    title: 'Health Reports',
    desc: 'Reads disease, pests, and nutrient deficiency from a single photo.',
    accent: 'from-krish-green-light to-krish-green-lighter',
    stat: '40+ conditions',
  },
  {
    key: 'remedies' as const,
    title: 'Remedies',
    desc: 'Plain-language, step-by-step treatment plans a farmer can act on today.',
    accent: 'from-krish-brown to-krish-brown-light',
    stat: 'In your language',
  },
  {
    key: 'community' as const,
    title: 'Community',
    desc: 'Ask, share, and learn from thousands of growers near you.',
    accent: 'from-krish-amber to-krish-brown-light',
    stat: '1,000+ farmers',
  },
];

export default function FeaturesGrid() {
  return (
    <section className="relative px-6 py-24 sm:py-32">
      <div className="mx-auto max-w-5xl">
        <div className="mb-14 text-center">
          <motion.p
            initial={{ opacity: 0, y: 16 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ type: 'spring', stiffness: 100, damping: 16 }}
            className="mb-3 text-xs font-bold uppercase tracking-[0.25em] text-krish-brown"
          >
            Built for the field, not the cloud
          </motion.p>
          <motion.h2
            initial={{ opacity: 0, y: 24 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ type: 'spring', stiffness: 80, damping: 16 }}
            className="font-display text-4xl font-extrabold text-krish-dark sm:text-5xl"
          >
            Everything you need, offline.
          </motion.h2>
        </div>

        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2">
          {features.map((f, i) => {
            const Icon = icons[f.key];
            return (
              <motion.div
                key={f.key}
                initial={{ opacity: 0, y: 50 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true, margin: '-60px' }}
                transition={{
                  type: 'spring',
                  stiffness: 70,
                  damping: 16,
                  delay: i * 0.1,
                }}
                whileHover={{ y: -8 }}
                className="group relative overflow-hidden rounded-3xl border border-krish-green/10 bg-white p-8 shadow-[0_10px_40px_-15px_rgba(45,106,79,0.25)] transition-shadow hover:shadow-[0_24px_60px_-20px_rgba(45,106,79,0.45)]"
              >
                {/* hover wash */}
                <div
                  className={`pointer-events-none absolute inset-0 bg-gradient-to-br ${f.accent} opacity-0 transition-opacity duration-500 group-hover:opacity-[0.06]`}
                />
                {/* icon */}
                <div className="mb-5 inline-flex h-16 w-16 items-center justify-center rounded-2xl bg-krish-cream-deep text-krish-green transition-transform duration-500 group-hover:scale-110 group-hover:rotate-3">
                  <Icon />
                </div>

                <h3 className="mb-2 text-2xl font-bold text-krish-dark">
                  {f.title}
                </h3>
                <p className="max-w-sm text-base leading-relaxed text-krish-dark/65">
                  {f.desc}
                </p>

                <span className="mt-5 inline-block rounded-full bg-krish-green/10 px-3 py-1 text-xs font-bold text-krish-green">
                  {f.stat}
                </span>

                {/* corner leaf accent */}
                <svg
                  className="pointer-events-none absolute -bottom-3 -right-3 h-20 w-20 text-krish-green opacity-[0.06] transition-transform duration-700 group-hover:rotate-45"
                  viewBox="0 0 48 48"
                  fill="currentColor"
                  aria-hidden
                >
                  <path d="M24 4C34 12 40 19 40 28a16 16 0 1 1-32 0c0-9 6-16 16-24z" />
                </svg>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
