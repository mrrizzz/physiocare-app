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
import { Skeleton } from "@/components/ui/skeleton";
import LogoutButton from "@/components/auth/logout-button";
import { useAuthToken } from "@/hooks/use-auth-token";

const menuUserItems = [
  { icon: Home, label: "Home", href: "/dashboard" },
  { icon: Calendar, label: "Scheduling", href: "/dashboard/scheduling" },
  { icon: FileText, label: "Medical Records", href: "/dashboard/records" },
  { icon: CreditCard, label: "Service", href: "/dashboard/services" },
];

const menuStaffItems = [
  { icon: Home, label: "Home", href: "/dashboard" },
  { icon: Calendar, label: "Scheduling", href: "/dashboard/scheduling" },
  { icon: FileText, label: "Medical Records", href: "/dashboard/records" },
];

export default function SidebarComponent() {
  const pathname = usePathname();
  const { userData, loading } = useAuthToken();
  const menuItems = userData?.role === "STAFF" ? menuStaffItems : menuUserItems;

  return (
    <Sidebar className="border-r">
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton size="lg" asChild>
              <div className="flex items-center gap-3">
                {loading ? (
                  <>
                    <Skeleton className="h-10 w-10 rounded-full" />
                    <div className="space-y-2">
                      <Skeleton className="h-4 w-[100px]" />
                      <Skeleton className="h-3 w-[120px]" />
                    </div>
                  </>
                ) : (
                  <>
                    <Avatar>
                      <AvatarImage
                        src={userData?.avatar || "/avatar.png"}
                        alt={userData?.username || "User"}
                      />
                      <AvatarFallback>
                        {userData?.username?.charAt(0) || "U"}
                      </AvatarFallback>
                    </Avatar>
                    <div className="flex flex-col gap-0.5 leading-none">
                      <span className="font-semibold">
                        {userData?.username || "User"}
                      </span>
                      <span className="text-xs text-muted-foreground">
                        {userData?.email || "user@example.com"}
                      </span>
                    </div>
                  </>
                )}
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
                href={`/dashboard/profile/${userData?.id}`}
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
