'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { ReactNode } from 'react';

interface ActiveLinkProps {
  children: ReactNode;
  href: string;
  className?: string;
  activeClassName?: string;
  exactMatch?: boolean;
  onClick?: () => void;
}

export function ActiveLink({
  children,
  href,
  className = '',
  activeClassName = 'text-primary-600 dark:text-primary-400',
  exactMatch = false,
  onClick,
}: ActiveLinkProps) {
  const pathname = usePathname();
  
  const isActive = exactMatch
    ? pathname === href
    : pathname === href || (href !== '/' && pathname.startsWith(href));

  return (
    <Link
      href={href}
      className={`${className} ${isActive ? activeClassName : ''}`}
      onClick={onClick}
    >
      {children}
    </Link>
  );
} 