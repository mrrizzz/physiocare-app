"use client";

import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { toast } from "@/hooks/use-toast";

export default function LogoutButton() {
  const router = useRouter();

  const handleLogout = async () => {
    try {
      const response = await fetch("/api/auth/logout", {
        method: "POST",
      });

      console.log("Logout response:", response);

      if (response.ok) {
        localStorage.removeItem("token");
        toast({
          title: "Logout Successful",
          description: "You will be redirected to the login page",
        });
        router.push("/auth");
      } else {
        console.error("Logout failed");
      }
    } catch (error) {
      console.error("Logout error:", error);
    }
  };

  return (
    <Button onClick={handleLogout} variant="outline">
      Logout
    </Button>
  );
}
