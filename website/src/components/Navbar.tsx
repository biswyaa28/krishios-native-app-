"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import Image from "next/image";
import { Menu, X, ArrowUpRight } from "lucide-react";
import { GithubIcon } from "./Icons";

export default function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 20);
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 py-5 px-4 sm:px-8 flex justify-center">
      
      {/* Floating Rounded Pill Navigation Container */}
      <div className="w-full max-w-6xl pill-navbar rounded-full px-6 sm:px-8 py-3 flex items-center justify-between">
        
        {/* Brand Logo Image */}
        <Link href="/" className="flex items-center gap-3 group">
          <div className="relative w-9 h-9 rounded-full overflow-hidden border border-[#1A2919]/10 shadow-sm group-hover:scale-105 transition-transform bg-white flex items-center justify-center">
            <Image
              src="/logo.png"
              alt="KrishiOS Logo"
              width={36}
              height={36}
              className="object-cover"
              priority
            />
          </div>
          <span className="text-lg font-bold tracking-tight text-[#1A2919] text-serif-editorial">
            KrishiOS
          </span>
        </Link>

        {/* Desktop Editorial Navigation Links */}
        <div className="hidden md:flex items-center gap-8 text-xs font-medium text-[#1A2919]/80 tracking-wide">
          <Link href="/#about" className="hover:text-[#233B22] transition-colors">
            About Us
          </Link>
          <Link href="/#features" className="hover:text-[#233B22] transition-colors">
            Architecture
          </Link>
          <Link href="/experience" className="hover:text-[#233B22] transition-colors">
            Experience
          </Link>
          <Link href="/#download" className="hover:text-[#233B22] transition-colors">
            Download
          </Link>
          <Link href="/#team" className="hover:text-[#233B22] transition-colors">
            Team 4 Brain
          </Link>
        </div>

        {/* Action Controls */}
        <div className="hidden md:flex items-center gap-3">
          <a
            href="https://github.com/ZoroDev0/KrishiOS.git"
            target="_blank"
            rel="noopener noreferrer"
            className="w-9 h-9 rounded-full bg-[#F6F4ED] border border-[#1A2919]/10 flex items-center justify-center text-[#1A2919] hover:bg-[#233B22] hover:text-[#F6F4ED] transition-all"
            aria-label="GitHub Repository"
          >
            <GithubIcon className="w-4 h-4" />
          </a>

          {/* Launch Web App Button */}
          <Link
            href="/app/index.html"
            className="flex items-center gap-2 px-5 py-2 rounded-full bg-[#233B22] text-[#F6F4ED] text-xs font-medium hover:bg-[#1B2E1A] shadow-md transition-all hover:scale-[1.02]"
          >
            <span>Launch Web App</span>
            <ArrowUpRight className="w-3.5 h-3.5" />
          </Link>
        </div>

        {/* Mobile Menu Toggle */}
        <button
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          className="md:hidden w-9 h-9 rounded-full bg-[#233B22] text-[#F6F4ED] flex items-center justify-center"
          aria-label="Toggle Menu"
        >
          {mobileMenuOpen ? <X className="w-4 h-4" /> : <Menu className="w-4 h-4" />}
        </button>
      </div>

      {/* Mobile Menu Overlay */}
      {mobileMenuOpen && (
        <div className="md:hidden absolute top-20 left-4 right-4 pill-navbar rounded-3xl p-6 flex flex-col gap-4 text-sm font-medium text-[#1A2919] shadow-2xl animate-in slide-in-from-top duration-200">
          <Link
            href="/#about"
            onClick={() => setMobileMenuOpen(false)}
            className="py-2 border-b border-[#1A2919]/10"
          >
            About Us
          </Link>
          <Link
            href="/#features"
            onClick={() => setMobileMenuOpen(false)}
            className="py-2 border-b border-[#1A2919]/10"
          >
            Architecture
          </Link>
          <Link
            href="/experience"
            onClick={() => setMobileMenuOpen(false)}
            className="py-2 border-b border-[#1A2919]/10"
          >
            Experience
          </Link>
          <Link
            href="/#download"
            onClick={() => setMobileMenuOpen(false)}
            className="py-2 border-b border-[#1A2919]/10"
          >
            Download
          </Link>
          <Link
            href="/#team"
            onClick={() => setMobileMenuOpen(false)}
            className="py-2 border-b border-[#1A2919]/10"
          >
            Team 4 Brain
          </Link>
          <Link
            href="/app/index.html"
            onClick={() => setMobileMenuOpen(false)}
            className="flex items-center justify-between py-2 text-[#233B22] font-bold"
          >
            <span>Launch Web App</span>
            <ArrowUpRight className="w-4 h-4" />
          </Link>
        </div>
      )}
    </nav>
  );
}
