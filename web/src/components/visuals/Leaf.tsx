interface LeafProps {
  className?: string;
  color?: string;
  size?: number;
}

/** A simple organic leaf shape, used as decoration & as the brand mark. */
export default function Leaf({ className = '', color = '#74C69D', size = 40 }: LeafProps) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 48 48"
      className={className}
      fill="none"
      aria-hidden
    >
      <path
        d="M24 4C34 12 40 19 40 28a16 16 0 1 1-32 0c0-9 6-16 16-24z"
        fill={color}
      />
      <path
        d="M24 8c7 6 12 11 12 18"
        stroke="rgba(0,0,0,0.12)"
        strokeWidth="1.2"
        strokeLinecap="round"
        fill="none"
      />
      <path
        d="M24 12v28M24 20l-6 4M24 20l6 4M24 28l-8 5M24 28l8 5"
        stroke="rgba(255,255,255,0.35)"
        strokeWidth="1.1"
        strokeLinecap="round"
        fill="none"
      />
    </svg>
  );
}
