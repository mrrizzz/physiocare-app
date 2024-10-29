"use client";

import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { LoginForm } from "@/components/auth/login-form";
import { SignUpForm } from "@/components/auth/signup-form";
import { useRouter } from "next/navigation";

export default function AuthPage() {
  const [activeTab, setActiveTab] = useState<"login" | "signup">("login");

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100">
      <Card className="w-full max-w-sm ">
        <CardHeader>
          <CardTitle className="text-center">Welcome</CardTitle>
        </CardHeader>
        <CardContent>
          <Tabs
            value={activeTab}
            onValueChange={(value) => setActiveTab(value as "login" | "signup")}
          >
            <TabsList className="grid w-full grid-cols-2">
              <TabsTrigger value="login">Login</TabsTrigger>
              <TabsTrigger value="signup">Sign Up</TabsTrigger>
            </TabsList>

            <TabsContent value="login">
              <LoginForm />
            </TabsContent>
            <TabsContent value="signup">
              <SignUpForm onSignUpSuccess={() => setActiveTab("login")} />
            </TabsContent>
          </Tabs>
        </CardContent>
      </Card>
    </div>
  );
}
