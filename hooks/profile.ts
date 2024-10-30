"use client";

import { UpdateProfileInput, UpdateProfileSchema } from "@/schema/profile";
import { zodResolver } from "@hookform/resolvers/zod";
import { useRouter } from "next/navigation";
import { useForm } from "react-hook-form";
import { toast, useToast } from "./use-toast";
import { useEffect, useState } from "react";
import { useAuthToken } from "./use-auth-token";
import { parseJWT } from "@/utils/jwt-decode";

export function UseProfileForm() {
  const router = useRouter();
  const { toast } = useToast();
  const { profile } = useProfile();

  const form = useForm<UpdateProfileInput>({
    resolver: zodResolver(UpdateProfileSchema),
    defaultValues: {
      name: profile?.name || "",
      age: profile?.age || undefined,
      address: profile?.address || "",
      dob: profile?.dob ? new Date(profile.dob) : undefined,
      gender: profile?.gender || "",
      phone: profile?.phone || "",
    },
  });

  // 2. Define a submit handler.
  const onSubmit = async (values: UpdateProfileInput) => {
    const token = localStorage.getItem("token");
    if (!token) {
      throw new Error("No token found");
    }
    const { id } = parseJWT(token);

    const response = await fetch("/api/profile", {
      method: "PUT",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(values),
    });

    const data = await response.json();
    console.log(data);
    if (response.ok) {
      toast({
        title: "Profile Updated",
        description: "Profile updated successfully",
      });
      router.push(`/dashboard/profile/${id}`);
      return data;
    } else {
      throw new Error(data.error);
    }
  };

  return { form, onSubmit, profile };
}

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

interface UseProfileReturn {
  profile: Profile | null;
  isLoading: boolean;
  refetch: () => Promise<void>;
}

export const useProfile = (): UseProfileReturn => {
  const [isLoading, setIsLoading] = useState(true);
  const [profile, setProfile] = useState<Profile | null>(null);

  const fetchProfile = async () => {
    setIsLoading(true);
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
      console.log(data);
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
  };

  useEffect(() => {
    fetchProfile();
  }, []);

  return {
    profile,
    isLoading,
    refetch: fetchProfile, // Expose refetch function for manual data refresh
  };
};
