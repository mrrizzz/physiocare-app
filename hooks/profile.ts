"use client";

import { UpdateProfileInput, UpdateProfileSchema } from "@/schema/profile";
import { zodResolver } from "@hookform/resolvers/zod";
import { useRouter } from "next/navigation";
import { useForm } from "react-hook-form";
import { useToast } from "./use-toast";

export function UseProfileForm() {
  const router = useRouter();
  const { toast } = useToast();
  const form = useForm<UpdateProfileInput>({
    resolver: zodResolver(UpdateProfileSchema),
    defaultValues: {
      name: "",
      age: undefined,
      address: "",
      dob: undefined,
      gender: "",
      phone: "",
    },
  });

  // 2. Define a submit handler.
  const onSubmit = async (values: UpdateProfileInput) => {
    const token = localStorage.getItem("token");

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
    return data;
    // Do something with the form values.
    // ✅ This will be type-safe and validated.
  };

  return { form, onSubmit };
}
