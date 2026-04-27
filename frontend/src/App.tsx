import { useState, useEffect, useRef } from 'react';
import {
  Route, MapPin, Brain, Ticket, Radio, Expand,
  Train, CableCar, Bus, Car, Menu, X, Instagram, Facebook,
  ChevronRight, Sparkles, Shield, Zap, Globe, ArrowDown
} from 'lucide-react';
import { teamMembers, features, transportTypes, TeamMember } from './data/team';
import './App.css';

const iconMap: Record<string, React.ElementType> = {
  Route, Brain, MapPin, Ticket, Radio, Expand,
  Train, CableCar, Bus, Car, Sparkles, Shield, Zap, Globe
};

function App() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [visibleSections, setVisibleSections] = useState<Set<string>>(new Set());

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 50);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            setVisibleSections((prev) => new Set([...prev, entry.target.id]));
          }
        });
      },
      { threshold: 0.1 }
    );

    document.querySelectorAll('section[id]').forEach((section) => {
      observer.observe(section);
    });

    return () => observer.disconnect();
  }, []);

  const scrollToSection = (id: string) => {
    document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' });
    setMobileMenuOpen(false);
  };

  return (
    <div className="min-h-screen bg-[oklch(0.13_0.02_280)] text-white overflow-x-hidden font-cairo relative">
      {/* PERFORMANCE-OPTIMIZED GRADIENT BACKGROUND */}
      {/* Only 3 gradient orbs + 2 subtle glows, all GPU-accelerated */}
      <div className="gradient-bg">
        <div className="gradient-orb gradient-orb-1"></div>
        <div className="gradient-orb gradient-orb-2"></div>
        <div className="gradient-orb gradient-orb-3"></div>
        <div className="subtle-glow glow-top"></div>
        <div className="subtle-glow glow-bottom"></div>
      </div>

      {/* Egyptian Flag Stripe */}
      <div className="fixed top-0 left-0 right-0 h-[3px] z-[60] flex neon-glow">
        <div className="flex-1 bg-egypt-red"></div>
        <div className="flex-1 bg-egypt-white"></div>
        <div className="flex-1 bg-egypt-black"></div>
      </div>

      {/* Navigation */}
      <nav className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        isScrolled ? 'bg-[oklch(0.13_0.02_280)]/95 backdrop-blur-xl shadow-lg shadow-sekka-cyan/10' : 'bg-transparent'
      }`}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center gap-3 group cursor-pointer" onClick={() => scrollToSection('hero')}>
              <img
                src="/sekka-profile-final.png"
                alt="Sekka Logo"
                className="h-10 w-10 object-contain transition-transform duration-300 group-hover:scale-110"
              />
              <span className="font-poppins font-bold text-xl bg-gradient-to-r from-sekka-cyan via-sekka-blue to-sekka-pink bg-clip-text text-transparent">
                Sekka
              </span>
            </div>

            <div className="hidden md:flex items-center gap-8">
              {['About', 'Features', 'Team'].map((item, i) => (
                <button
                  key={item}
                  onClick={() => scrollToSection(item.toLowerCase())}
                  className="relative text-gray-300 hover:text-white transition-colors font-medium group"
                >
                  {item}
                  <span className="absolute -bottom-1 left-0 w-0 h-[2px] bg-gradient-to-r from-sekka-cyan to-sekka-purple transition-all duration-150 group-hover:w-full"></span>
                </button>
              ))}
              <button className="px-6 py-2.5 bg-gradient-to-r from-sekka-cyan via-sekka-blue to-sekka-purple rounded-full font-semibold hover:shadow-[0_0_20px_rgba(0,212,255,0.3)] transition-all duration-150 transform hover:scale-105">
                Get App
              </button>
            </div>

            <button
              className="md:hidden text-white p-2 hover:bg-white/10 rounded-lg transition-colors"
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            >
              {mobileMenuOpen ? <X size={24} /> : <Menu size={24} />}
            </button>
          </div>
        </div>

        {/* Mobile Menu */}
        {mobileMenuOpen && (
          <div className="md:hidden bg-[oklch(0.15_0.02_280)]/98 backdrop-blur-2xl border-t border-white/10 animate-slideDown">
            <div className="px-4 py-6 space-y-4">
              {['About', 'Features', 'Team'].map((item) => (
                <button
                  key={item}
                  onClick={() => scrollToSection(item.toLowerCase())}
                  className="block w-full text-left text-gray-300 hover:text-sekka-cyan py-3 text-lg font-medium transition-colors"
                >
                  {item}
                </button>
              ))}
              <button className="w-full px-6 py-3 bg-gradient-to-r from-sekka-cyan to-sekka-purple rounded-full font-semibold text-lg">
                Get App
              </button>
            </div>
          </div>
        )}
      </nav>

      {/* Hero Section */}
      <section id="hero" className="relative min-h-screen flex items-center justify-center overflow-hidden">
        {/* Egypt Flag Video Background (subtle, behind) */}
        <div className="absolute inset-0 z-0">
          <video
            autoPlay
            loop
            muted
            playsInline
            className="w-full h-full object-cover opacity-[0.15]"
          >
            <source src="/egypt-flag.mp4" type="video/mp4" />
          </video>
        </div>

        {/* Main Video Background */}
        <div className="absolute inset-0 z-[1]">
          <video
            autoPlay
            loop
            muted
            playsInline
            className="w-full h-full object-cover"
          >
            <source src="/SEKKAINTROVIDEO.mp4" type="video/mp4" />
          </video>
          <div className="absolute inset-0 bg-gradient-to-b from-[oklch(0.13_0.02_280)]/90 via-[oklch(0.13_0.02_280)]/50 to-[oklch(0.13_0.02_280)]"></div>
        </div>

        {/* Hero Gradient Orbs - Moved away from center, GPU Accelerated */}
        <div className="absolute inset-0 z-[2] overflow-hidden pointer-events-none">
          <div className="absolute -top-[10%] -left-[15%] w-[500px] h-[500px] bg-sekka-cyan/15 rounded-full animate-float" style={{ animationDelay: '0s' }}></div>
          <div className="absolute -top-[5%] -right-[20%] w-[450px] h-[450px] bg-sekka-purple/15 rounded-full animate-float" style={{ animationDelay: '-6s' }}></div>
          <div className="absolute -bottom-[15%] left-[60%] w-[400px] h-[400px] bg-sekka-pink/10 rounded-full animate-float" style={{ animationDelay: '-12s' }}></div>
        </div>

        {/* Hero Content - NO LOGO */}
        <div className="relative z-20 text-center px-4 max-w-5xl mx-auto">
          <h1 className="font-poppins text-7xl md:text-[8rem] font-black mb-6 animate-fadeInUp">
            <span className="bg-gradient-to-r from-sekka-cyan via-sekka-blue via-sekka-purple to-sekka-pink bg-[length:200%_200%] animate-gradient-shift bg-clip-text text-transparent drop-shadow-[0_0_30px_rgba(0,212,255,0.5)]">
              Sekka
            </span>
            <span className="block text-5xl md:text-6xl mt-4 text-white/95 font-cairo font-bold animate-fadeInUp" style={{ animationDelay: '0.2s' }}>
              سكة
            </span>
          </h1>

          <p className="text-xl md:text-3xl text-gray-300 mb-8 font-cairo animate-fadeInUp" style={{ animationDelay: '0.4s' }}>
            Egypt's First Unified Smart Transport App
          </p>
          <p className="text-lg md:text-2xl text-sekka-cyan mb-16 font-cairo animate-fadeInUp" style={{ animationDelay: '0.6s' }}>
            التطبيق الذكي الأول في مصر للنقل المتكامل
          </p>

          <div className="flex flex-col sm:flex-row gap-6 justify-center animate-fadeInUp" style={{ animationDelay: '0.8s' }}>
            <button className="group px-10 py-5 bg-gradient-to-r from-sekka-cyan via-sekka-blue to-sekka-purple rounded-full font-bold text-lg shadow-[0_0_40px_rgba(0,212,255,0.3)] hover:shadow-[0_0_60px_rgba(0,212,255,0.5)] transition-all duration-500 flex items-center justify-center gap-3 transform hover:scale-105">
              Download App
              <ChevronRight className="w-5 h-5 group-hover:translate-x-2 transition-transform duration-300" />
            </button>
            <button
              onClick={() => scrollToSection('about')}
              className="px-10 py-5 border-2 border-white/40 rounded-full font-bold text-lg hover:bg-white/10 hover:border-sekka-cyan/60 transition-all duration-300 backdrop-blur-sm"
            >
              Learn More
            </button>
          </div>

          {/* Transport Icons - ANIMATED GRADIENT LABELS */}
          <div className="flex justify-center gap-12 mt-20 animate-fadeInUp" style={{ animationDelay: '1s' }}>
            {[
              { icon: Train, label: 'Metro' },
              { icon: CableCar, label: 'Monorail' },
              { icon: Bus, label: 'Bus' },
              { icon: Car, label: 'Microbus' }
            ].map(({ icon: Icon, label }, i) => (
              <div
                key={label}
                className="flex flex-col items-center gap-3 transition-all duration-300 transform hover:scale-110 group cursor-pointer"
              >
                <div className="w-16 h-16 rounded-2xl bg-white/5 backdrop-blur-sm border border-white/10 flex items-center justify-center group-hover:bg-sekka-cyan/20 group-hover:border-sekka-cyan/40 transition-all duration-300 group-hover:shadow-[0_0_25px_rgba(0,212,255,0.3)]">
                  <Icon className="w-8 h-8 group-hover:text-sekka-cyan transition-colors duration-300" />
                </div>
                <span className="transport-label text-sm font-bold bg-gradient-to-r from-sekka-cyan via-sekka-purple to-sekka-pink bg-clip-text text-transparent bg-[length:200%_200%] animate-gradient-shift group-hover:opacity-80 transition-opacity">
                  {label}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* Enhanced Scroll Indicator */}
        <div className="absolute bottom-12 left-1/2 -translate-x-1/2 z-20 animate-bounce">
          <button
            onClick={() => scrollToSection('about')}
            className="w-14 h-20 border-2 border-white/30 rounded-full flex flex-col items-center justify-center gap-2 hover:border-sekka-cyan/60 hover:bg-white/5 transition-all duration-300 group"
          >
            <span className="text-xs text-white/60 group-hover:text-sekka-cyan transition-colors">Scroll</span>
            <ArrowDown className="w-4 h-4 text-white/50 group-hover:text-sekka-cyan animate-bounce" />
          </button>
        </div>
      </section>

      {/* About Section with Video */}
      <section id="about" className="py-20 md:py-32 px-4">
        <div className="max-w-7xl mx-auto">
          {/* Section Headers - Always Visible - ANIMATED GRADIENT TITLES */}
          <div className="text-center mb-12 md:mb-20">
            <h2 className="font-poppins text-4xl md:text-6xl lg:text-7xl font-black mb-4 md:mb-6">
              <span className="animated-title-gradient">
                What is Sekka?
              </span>
            </h2>
            <p className="text-xl md:text-2xl lg:text-4xl font-bold font-cairo mt-2 md:mt-4">
              <span className="glow-animated-text arabic-animated-title">
                ما هي سكة؟
              </span>
            </p>
          </div>

          {/* Video + Description Layout */}
          <div className="grid lg:grid-cols-2 gap-8 lg:gap-12 items-start mb-16 md:mb-24">
            {/* Left Side - Descriptions */}
            <div className="space-y-6 lg:space-y-8 order-2 lg:order-1">
              {/* English Description */}
              <div className="glass-card p-6 md:p-8 lg:p-10 rounded-2xl md:rounded-3xl hover:shadow-[0_0_30px_rgba(0,212,255,0.15)] transition-all duration-150 transform hover:-translate-y-1">
                <h3 className="font-poppins text-2xl md:text-3xl font-bold mb-4 md:mb-6">
                  <span className="bg-gradient-to-r from-sekka-cyan to-sekka-pink bg-clip-text text-transparent">Our Story</span>
                </h3>
                <p className="text-gray-300 leading-relaxed text-base md:text-lg mb-4 md:mb-6">
                  We saw people lost in Egypt's transport maze, frustrated and confused about which route to take.
                  Commuters struggled to navigate between Metro, Monorail, Buses, and microbuses — each with its own system.
                </p>
                <p className="text-gray-300 leading-relaxed text-base md:text-lg">
                  So we created <span className="text-sekka-cyan font-bold neon-text">Sekka</span> — a unified platform that brings
                  all transportation modes together. One app to rule them all.
                </p>
              </div>

              {/* Arabic Description */}
              <div className="glass-card p-6 md:p-8 lg:p-10 rounded-2xl md:rounded-3xl hover:shadow-[0_0_30px_rgba(139,92,246,0.15)] transition-all duration-150 transform hover:-translate-y-1">
                <h3 className="font-poppins text-2xl md:text-3xl font-bold mb-4 md:mb-6 text-right">
                  <span className="bg-gradient-to-r from-sekka-purple to-sekka-pink bg-clip-text text-transparent">قصتنا</span>
                </h3>
                <p className="text-gray-300 leading-relaxed text-base md:text-lg mb-4 md:mb-6 text-right font-cairo">
                  رأينا الناس تائهة في متاهة النقل في مصر، محبطة ومترددة في معرفة أي طريق تسلك.
                  كان الركاب يكافحون للتنقل بين المترو والمونوريل والأتوبيسات والميكروباصات — كلٌ بنظامه الخاص.
                </p>
                <p className="text-gray-300 leading-relaxed text-base md:text-lg text-right font-cairo">
                  لذلك أنشأنا <span className="text-sekka-cyan font-bold neon-text">سكة</span> — منصة موحدة تجمع جميع وسائل النقل.
                  تطبيق واحد يربطهم جميعاً.
                </p>
              </div>
            </div>

            {/* Right Side - Video with Phone Mockup */}
            <div className="order-1 lg:order-2">
              {/* Phone Mockup Container - Taller phone like iPhone */}
              <div className="relative mx-auto w-full max-w-[260px] sm:max-w-[280px] md:max-w-[300px] lg:max-w-[320px]">
                {/* Phone Frame */}
                <div className="relative bg-gradient-to-b from-[#1a1a2e] to-[#0d0d1a] rounded-[36px] md:rounded-[44px] p-2 md:p-3 shadow-[0_25px_50px_-12px_rgba(0,0,0,0.5),0_0_60px_rgba(0,212,255,0.2)] border border-white/10">
                  {/* Phone Screen Container */}
                  <div className="relative rounded-[32px] md:rounded-[38px] overflow-hidden bg-black">
                    {/* Notch */}
                    <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[100px] md:w-[120px] h-[32px] md:h-[36px] bg-[#0d0d1a] rounded-b-2xl md:rounded-b-3xl z-20 flex items-center justify-center">
                      <div className="w-3 md:w-4 h-3 md:h-4 bg-[#1a1a2e] rounded-full"></div>
                    </div>

                    {/* Video Screen - Taller aspect ratio like modern phones */}
                    <div className="relative w-full" style={{ aspectRatio: '9/19.5' }}>
                      <video
                        ref={(el) => {
                          if (el) {
                            const observer = new IntersectionObserver(
                              (entries) => {
                                entries.forEach((entry) => {
                                  if (entry.isIntersecting) {
                                    el.play().catch(() => {});
                                    el.loop = true;
                                  } else {
                                    el.pause();
                                    el.currentTime = 0;
                                  }
                                });
                              },
                              { threshold: 0.5 }
                            );
                            observer.observe(el);
                            return () => observer.disconnect();
                          }
                        }}
                        src="/SEKKA_Auth.webm"
                        autoPlay
                        muted
                        loop
                        playsInline
                        preload="metadata"
                        className="w-full h-full object-cover object-top"
                        poster="/sekka-profile-final.png"
                      >
                        Your browser does not support the video tag.
                      </video>
                    </div>
                  </div>

                  {/* Side Buttons */}
                  <div className="absolute -left-[2px] top-[90px] md:top-[110px] w-[2px] md:w-[3px] h-[25px] md:h-[35px] bg-[#2a2a3e] rounded-l-full"></div>
                  <div className="absolute -left-[2px] top-[130px] md:top-[160px] w-[2px] md:w-[3px] h-[40px] md:h-[50px] bg-[#2a2a3e] rounded-l-full"></div>
                  <div className="absolute -right-[2px] top-[110px] md:top-[130px] w-[2px] md:w-[3px] h-[50px] md:h-[60px] bg-[#2a2a3e] rounded-r-full"></div>
                </div>

                {/* Phone Glow Effect - Lightweight */}
                <div className="absolute inset-0 rounded-[36px] md:rounded-[44px] bg-gradient-to-b from-sekka-cyan/15 to-sekka-purple/15 -z-10 opacity-40"></div>
              </div>
            </div>
          </div>

          {/* Transport Type Cards with Enhanced Neon */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-8">
            {transportTypes.map((transport, index) => {
              const Icon = iconMap[transport.icon];
              return (
                <div
                  key={transport.name}
                  className="glass-card p-4 md:p-6 lg:p-8 rounded-2xl md:rounded-3xl text-center group hover:scale-105 transition-all duration-150"
                >
                  <div className="w-14 h-14 md:w-20 lg:w-20 mx-auto mb-4 md:mb-6 rounded-xl md:rounded-2xl bg-gradient-to-br from-sekka-cyan/20 via-sekka-purple/20 to-sekka-pink/20 flex items-center justify-center group-hover:from-sekka-cyan/40 group-hover:via-sekka-purple/40 group-hover:to-sekka-pink/40 transition-all duration-150 group-hover:scale-110">
                    {Icon && <Icon className="w-7 h-7 md:w-10 lg:w-10 text-sekka-cyan group-hover:text-white transition-colors duration-150" />}
                  </div>
                  <h4 className="font-poppins font-bold text-base md:text-xl mb-2 transition-colors">
                    <span className="card-animated-title group-hover:opacity-80 transition-opacity">{transport.name}</span>
                  </h4>
                  <p className="text-sekka-cyan text-sm md:text-base mb-2 md:mb-4 font-cairo">{transport.nameAr}</p>
                  <p className="text-gray-400 text-xs md:text-sm hidden md:block">{transport.description}</p>
                  <p className="text-gray-500 text-xs md:hidden font-cairo">{transport.descriptionAr}</p>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* Features Section with Neon Effects */}
      <section id="features" className={`py-20 md:py-32 px-4 transition-all duration-1000 ${visibleSections.has('features') ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-10'}`}>
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-12 md:mb-20">
            <h2 className="font-poppins text-4xl md:text-6xl lg:text-7xl font-black mb-4 md:mb-6">
              <span className="animated-title-gradient">
                Powerful Features
              </span>
            </h2>
            <p className="text-xl md:text-2xl font-cairo">
              <span className="glow-animated-text arabic-animated-title">ميزات قوية</span>
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 md:gap-8">
            {features.map((feature, index) => {
              const Icon = iconMap[feature.icon];
              return (
                <div
                  key={feature.title}
                  className="glass-card p-6 md:p-8 rounded-2xl md:rounded-3xl group hover:scale-[1.03] hover:shadow-[0_0_40px_rgba(0,212,255,0.15)] transition-all duration-150"
                >
                  <div className="w-14 h-14 md:w-16 md:h-16 rounded-xl md:rounded-2xl bg-gradient-to-br from-sekka-cyan/20 to-sekka-purple/30 flex items-center justify-center mb-4 md:mb-6 group-hover:from-sekka-cyan/50 group-hover:to-sekka-purple/60 transition-all duration-150 group-hover:scale-110 group-hover:shadow-[0_0_20px_rgba(0,212,255,0.3)]">
                    {Icon && <Icon className="w-7 h-7 md:w-8 md:h-8 text-sekka-cyan group-hover:text-white transition-colors duration-150" />}
                  </div>
                  <h3 className="font-poppins font-bold text-xl md:text-2xl mb-2 md:mb-3 transition-colors">
                    <span className="bg-gradient-to-r from-sekka-cyan via-sekka-purple to-sekka-pink bg-clip-text text-transparent group-hover:opacity-80 transition-opacity">{feature.title}</span>
                  </h3>
                  <p className="text-sekka-cyan text-base md:text-lg mb-3 md:mb-4 font-cairo group-hover:text-sekka-pink transition-colors">{feature.titleAr}</p>
                  <p className="text-gray-400 text-sm md:text-base mb-2 md:mb-3">{feature.description}</p>
                  <p className="text-gray-500 text-xs md:text-sm font-cairo">{feature.descriptionAr}</p>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* Team Section */}
      <section id="team" className={`py-20 md:py-32 px-4 transition-all duration-1000 ${visibleSections.has('team') ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-10'}`}>
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-12 md:mb-20">
            <h2 className="font-poppins text-4xl md:text-6xl lg:text-7xl font-black mb-4 md:mb-6">
              <span className="animated-title-gradient">
                Meet the Team
              </span>
            </h2>
            <p className="text-xl md:text-2xl font-cairo">
              <span className="glow-animated-text arabic-animated-title">تعرف على الفريق</span>
            </p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 md:gap-10">
            {teamMembers.map((member, index) => (
              <TeamCard key={member.name} member={member} />
            ))}
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-20 px-4 border-t border-white/10 bg-[oklch(0.11_0.02_280)] relative overflow-hidden">
        {/* Neon accent lines */}
        <div className="absolute top-0 left-0 right-0 h-[1px] bg-gradient-to-r from-transparent via-sekka-cyan/50 to-transparent"></div>
        <div className="absolute top-[2px] left-0 right-0 h-[1px] bg-gradient-to-r from-transparent via-sekka-purple/30 to-transparent"></div>

        <div className="max-w-7xl mx-auto relative z-10">
          <div className="grid md:grid-cols-3 gap-12 mb-16">
            {/* Logo & Description */}
            <div>
              <div className="flex items-center gap-3 mb-6 group cursor-pointer" onClick={() => scrollToSection('hero')}>
                <img
                  src="/sekka-profile-final.png"
                  alt="Sekka Logo"
                  className="h-14 w-14 object-contain transition-transform duration-300 group-hover:scale-110"
                />
                <span className="font-poppins font-bold text-3xl animated-title-gradient">
                  Sekka
                </span>
              </div>
              <p className="text-gray-400 mb-4 font-cairo text-lg">
                Egypt's first unified smart transportation app. One platform for all your transport needs.
              </p>
              <p className="text-gray-500 font-cairo text-base">
                أول تطبيق ذكي للنقل المتكامل في مصر. منصة واحدة لجميع احتياجاتك في المواصلات.
              </p>
            </div>

            {/* Quick Links */}
            <div>
              <h4 className="font-poppins font-bold text-xl mb-6">
                <span className="animated-title">Quick Links</span>
              </h4>
              <ul className="space-y-4">
                {['About', 'Features', 'Team', 'Download'].map((link) => (
                  <li key={link}>
                    <button
                      onClick={() => scrollToSection(link.toLowerCase())}
                      className="text-gray-400 hover:text-sekka-cyan transition-colors text-lg relative group"
                    >
                      {link}
                      <span className="absolute -bottom-1 left-0 w-0 h-[2px] bg-sekka-cyan transition-all duration-300 group-hover:w-full"></span>
                    </button>
                  </li>
                ))}
              </ul>
            </div>

            {/* Social & QR Codes */}
            <div>
              <h4 className="font-poppins font-bold text-xl mb-6">
                <span className="animated-title">Connect With Us</span>
              </h4>
              <div className="flex gap-6 mb-8">
                <a
                  href="https://instagram.com/sekka_2026"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-gray-400 hover:text-sekka-pink transition-all duration-300 transform hover:scale-125 hover:drop-shadow-[0_0_20px_rgba(236,72,153,0.5)]"
                >
                  <Instagram size={32} />
                </a>
                <a
                  href="#"
                  className="text-gray-400 hover:text-sekka-blue transition-all duration-300 transform hover:scale-125 hover:drop-shadow-[0_0_20px_rgba(79,70,229,0.5)]"
                >
                  <Facebook size={32} />
                </a>
              </div>
              <div className="flex gap-6">
                <div className="bg-white p-2 sm:p-3 rounded-2xl neon-border transform hover:scale-105 transition-all duration-300 w-28 h-28 sm:w-32 sm:h-32 flex items-center justify-center overflow-hidden">
                  <img src="/SEKKAINSTAGRAM.png" alt="Instagram QR" className="w-full h-full object-cover" />
                </div>
                <div className="bg-white p-2 sm:p-3 rounded-2xl neon-border transform hover:scale-105 transition-all duration-300 w-28 h-28 sm:w-32 sm:h-32 flex items-center justify-center overflow-hidden">
                  <img src="/SEKKAFACEBOOK.png" alt="Facebook QR" className="w-full h-full object-cover" />
                </div>
              </div>
            </div>
          </div>

          {/* Egyptian Flag Accent */}
          <div className="flex h-[3px] mb-10 rounded-full overflow-hidden neon-glow">
            <div className="flex-1 bg-egypt-red"></div>
            <div className="flex-1 bg-egypt-white"></div>
            <div className="flex-1 bg-egypt-black"></div>
          </div>

          <div className="text-center">
            <p className="font-cairo text-lg text-gray-400">
              © 2026 Sekka. All rights reserved. Made with ❤️ in Egypt.
            </p>
            <p className="font-cairo mt-3 text-base text-gray-500">
              جميع الحقوق محفوظة © 2026 سكة. صنع بـ ❤️ في مصر
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}

function TeamCard({ member }: { member: TeamMember }) {
  const [isHovered, setIsHovered] = useState(false);

  return (
    <div
      className="glass-card rounded-2xl md:rounded-3xl p-4 md:p-8 text-center group hover:scale-[1.05] hover:shadow-[0_0_50px_rgba(0,212,255,0.25)] transition-all duration-300 relative overflow-hidden"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      {/* Enhanced glow background on hover */}
      <div className={`absolute inset-0 bg-gradient-to-br from-sekka-cyan/10 via-sekka-purple/10 to-sekka-pink/10 opacity-0 group-hover:opacity-100 transition-opacity duration-300`}></div>

      <div className="relative mb-4 md:mb-6 mx-auto w-24 h-24 md:w-36 md:h-36">
        {/* Rotating gradient border with sweep effect */}
        <div className={`absolute inset-0 rounded-full transition-all duration-300 ${isHovered ? 'scale-110' : ''}`}>
          <div className="absolute inset-0 rounded-full profile-border-glow">
            <div className="w-full h-full rounded-full animate-gradient-rotate"></div>
          </div>
          <div className={`absolute inset-0 rounded-full bg-gradient-to-br from-sekka-cyan via-sekka-purple to-sekka-pink p-[2px] md:p-[3px] transition-shadow duration-300 ${isHovered ? 'shadow-[0_0_35px_rgba(0,212,255,0.5)] shadow-[0_0_35px_rgba(139,92,246,0.3)]' : 'opacity-80'}`}>
            <div className="w-full h-full rounded-full bg-[oklch(0.13_0.02_280)] p-1">
              <img
                src={member.image}
                alt={member.name}
                className="w-full h-full rounded-full object-cover"
                onError={(e) => {
                  const target = e.target as HTMLImageElement;
                  target.style.display = 'none';
                  target.parentElement!.innerHTML = `<div class="w-full h-full rounded-full bg-gradient-to-br from-sekka-cyan/30 to-sekka-purple/30 flex items-center justify-center text-xl md:text-3xl font-bold text-white">${member.name.split(' ').map(n => n[0]).join('')}</div>`;
                }}
              />
            </div>
          </div>
          {/* Glow sweep highlight */}
          <div className={`absolute inset-0 rounded-full glow-sweep transition-opacity duration-300 ${isHovered ? 'opacity-100' : 'opacity-0'}`}></div>
        </div>
        {isHovered && (
          <div className="absolute -top-2 -right-2 md:-top-3 md:-right-3 w-8 h-8 md:w-10 md:h-10 bg-gradient-to-r from-sekka-cyan to-sekka-purple rounded-full flex items-center justify-center animate-pulse shadow-[0_0_25px_rgba(0,212,255,0.6)] z-20">
            <Sparkles className="w-4 h-4 md:w-5 md:h-5 text-white" />
          </div>
        )}
      </div>

      <h3 className="font-poppins font-bold text-base md:text-xl mb-2 transition-colors relative z-10">
        <span className="bg-gradient-to-r from-sekka-cyan via-sekka-purple to-sekka-pink bg-clip-text text-transparent group-hover:opacity-80 transition-opacity">{member.name}</span>
      </h3>
      <p className="bg-gradient-to-r from-sekka-purple to-sekka-pink bg-clip-text text-transparent text-base mb-4 font-cairo relative z-10">{member.nameAr}</p>
      <div className="inline-block px-4 py-2 bg-gradient-to-r from-sekka-purple/20 to-sekka-pink/20 rounded-full mb-4 border border-sekka-purple/30 relative z-10 group-hover:border-sekka-cyan/50 group-hover:bg-gradient-to-r group-hover:from-sekka-cyan/20 group-hover:to-sekka-purple/20 transition-all duration-300">
        <span className="text-base font-bold text-sekka-pink group-hover:text-sekka-cyan transition-colors">{member.role}</span>
      </div>
      <p className="text-sm text-gray-400 hidden lg:block leading-relaxed relative z-10">{member.description}</p>
      <p className="text-xs text-gray-500 lg:hidden font-cairo leading-relaxed relative z-10">{member.descriptionAr}</p>
    </div>
  );
}

export default App;