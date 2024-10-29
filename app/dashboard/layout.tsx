import SidebarComponent from "@/components/dashboard/sidebar";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <SidebarProvider>
      {/* <Sidebar variant="inset" /> */}
      <SidebarComponent />
      <SidebarInset>
        <main className="flex-1 overflow-y-auto p-8">{children}</main>
      </SidebarInset>
    </SidebarProvider>
  );
}
