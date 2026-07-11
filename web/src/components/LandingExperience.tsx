import SmoothScroll from '../components/SmoothScroll';
import ScrollProgress from '../components/ScrollProgress';
import Hero from '../components/Hero';
import ProblemSolution from '../components/ProblemSolution';
import HowItWorks from '../components/HowItWorks';
import FeaturesGrid from '../components/FeaturesGrid';
import BrandStory from '../components/BrandStory';
import CommunityPreview from '../components/CommunityPreview';
import DownloadCta from '../components/DownloadCta';

export default function LandingExperience() {
  return (
    <SmoothScroll>
      <ScrollProgress />
      <main>
        <Hero />
        <ProblemSolution />
        <HowItWorks />
        <FeaturesGrid />
        <BrandStory />
        <CommunityPreview />
        <DownloadCta />
      </main>
    </SmoothScroll>
  );
}
