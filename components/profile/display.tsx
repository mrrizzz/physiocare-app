"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
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
  const [profile, setProfile] = useState<Profile | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    async function fetchProfile() {
      try {
        const token = localStorage.getItem("token");

        const response = await fetch("/api/profile", {
          method: "GET",
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
          },
        });
        const data = await response.json();
        setProfile(data.data);
      } catch (error) {
        toast({
          title: "Error",
          description: "Failed to load profile. Please try again later.",
          variant: "destructive",
        });
      } finally {
        setIsLoading(false);
      }
    }

    fetchProfile();
  }, []);

  const handleUpdateClick = () => {
    router.push("/dashboard/profile/update");
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
