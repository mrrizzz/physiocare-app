import SidebarComponent from "@/components/dashboard/sidebar";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <SidebarProvider>
      <SidebarComponent />
      <SidebarInset>
        <main className=" p-8">{children}</main>
      </SidebarInset>
    </SidebarProvider>
  );
}
