import SidebarComponent from "@/components/dashboard/sidebar";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <div className="container mx-auto max-w-2xl p-8">{children}</div>;
}
