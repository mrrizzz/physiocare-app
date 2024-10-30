"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Home, Calendar, FileText, CreditCard, User } from "lucide-react";
import { cn } from "@/lib/utils";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuItem,
  SidebarMenuButton,
  SidebarProvider,
  SidebarRail,
} from "@/components/ui/sidebar";
import LogoutButton from "@/components/auth/logout-button";

const menuItems = [
  { icon: Home, label: "Home", href: "/dashboard" },
  { icon: Calendar, label: "Scheduling", href: "/dashboard/scheduling" },
  { icon: FileText, label: "Medical Records", href: "/dashboard/records" },
  // { icon: CreditCard, label: "Payment", href: "/dashboard/payment" },
  { icon: CreditCard, label: "Service", href: "/dashboard/service" },
];

export default function SidebarComponent() {
  const pathname = usePathname();

  return (
    <Sidebar className="border-r">
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton size="lg" asChild>
              <div className="flex items-center gap-3">
                <Avatar>
                  <AvatarImage src="/avatar.png" alt="User" />
                  <AvatarFallback>JD</AvatarFallback>
                </Avatar>
                <div className="flex flex-col gap-0.5 leading-none">
                  <span className="font-semibold">John Doe</span>
                  <span className="text-xs text-muted-foreground">
                    john@example.com
                  </span>
                </div>
              </div>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>
      <SidebarContent>
        <SidebarMenu>
          {menuItems.map((item) => (
            <SidebarMenuItem key={item.href}>
              <SidebarMenuButton asChild>
                <Link
                  href={item.href}
                  className={cn(
                    "flex items-center gap-3",
                    pathname === item.href
                      ? "text-primary font-medium"
                      : "text-muted-foreground hover:text-primary"
                  )}
                >
                  <item.icon className="h-4 w-4" />
                  {item.label}
                </Link>
              </SidebarMenuButton>
            </SidebarMenuItem>
          ))}
        </SidebarMenu>
      </SidebarContent>
      <SidebarFooter>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton asChild>
              <Link
                href="/dashboard/profile"
                className="flex items-center gap-3 text-muted-foreground hover:text-primary"
              >
                <User className="h-4 w-4" />
                Profile Settings
              </Link>
            </SidebarMenuButton>
          </SidebarMenuItem>
          <SidebarMenuItem>
            <LogoutButton />
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarFooter>
      <SidebarRail />
    </Sidebar>
  );
}
