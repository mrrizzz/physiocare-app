"use client";

import { useState, useEffect } from "react";
import { usePathname, useRouter } from "next/navigation";
import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { User, Phone, MapPin, Cake } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";
import { toast } from "@/hooks/use-toast";
import { useProfile } from "@/hooks/profile";

interface Profile {
  id: string;
  name: string;
  age: number;
  address: string;
  dob: string;
  gender: string;
  phone: string;
  type: string;
}

export default function ProfilePage() {
  const pathname = usePathname();
  const router = useRouter();
  const { profile, isLoading, refetch } = useProfile();

  const handleUpdateClick = () => {
    const currentPath = pathname.split("/").pop();
    const updatePath = currentPath?.concat("/update");
    if (!updatePath) {
      return;
    }
    router.push(updatePath);
  };

  if (isLoading) {
    return (
      <div className="container mx-auto py-10">
        <Card className="w-full max-w-2xl mx-auto">
          <CardHeader>
            <Skeleton className="h-8 w-1/3" />
          </CardHeader>
          <CardContent className="space-y-4">
            {[...Array(5)].map((_, i) => (
              <Skeleton key={i} className="h-6 w-full" />
            ))}
          </CardContent>
        </Card>
      </div>
    );
  }

  if (!profile) {
    return (
      <div className="container mx-auto py-10 text-center">
        <p>No profile data available.</p>
      </div>
    );
  }

  return (
    <div className="container mx-auto py-10">
      <Card className="w-full max-w-2xl mx-auto">
        <CardHeader className="flex flex-row items-center gap-4">
          <Avatar className="h-16 w-16">
            <AvatarImage
              src={`https://api.dicebear.com/6.x/initials/svg?seed=${profile.name}`}
              alt={profile.name}
            />
            <AvatarFallback>{profile.name.charAt(0)}</AvatarFallback>
          </Avatar>
          <div>
            <CardTitle className="text-2xl">{profile.name}</CardTitle>
            <p className="text-sm text-muted-foreground">
              {profile.type} Account
            </p>
          </div>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center gap-2">
            <User className="h-5 w-5 text-muted-foreground" />
            <span>{profile.age} years old</span>
          </div>
          <div className="flex items-center gap-2">
            <MapPin className="h-5 w-5 text-muted-foreground" />
            <span>{profile.address}</span>
          </div>
          <div className="flex items-center gap-2">
            <Cake className="h-5 w-5 text-muted-foreground" />
            <span>{new Date(profile.dob).toLocaleDateString()}</span>
          </div>
          <div className="flex items-center gap-2">
            {/* <GenderMale className="h-5 w-5 text-muted-foreground" /> */}
            <span>{profile.gender}</span>
          </div>
          <div className="flex items-center gap-2">
            <Phone className="h-5 w-5 text-muted-foreground" />
            <span>{profile.phone}</span>
          </div>
        </CardContent>
        <CardFooter>
          <Button onClick={handleUpdateClick} className="w-full">
            Update Profile
          </Button>
        </CardFooter>
      </Card>
    </div>
  );
}
