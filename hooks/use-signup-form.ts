import { useRouter } from "next/navigation";
import { useToast } from "./use-toast";
import { SignUpInput, SignUpSchema } from "@/schema/auth";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";

export const useSignUpForm = (onSignUpSuccess?: () => void) => {
  const router = useRouter();
  const { toast } = useToast();

  const form = useForm<SignUpInput>({
    resolver: zodResolver(SignUpSchema),
    defaultValues: {
      username: "",
      email: "",
      password: "",
      confirmPassword: "",
    },
  });

  const onSubmit = async (values: SignUpInput) => {
    try {
      const response = await fetch("/api/auth/signup", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(values),
      });

      const data = await response.json();

      if (response.ok) {
        toast({
          title: "Signup Successful",
          description: "Please login with your new account",
        });
        // setActiveTab("login");
        onSignUpSuccess?.();
      } else {
        throw new Error(data.error);
      }
    } catch (error) {
      toast({
        variant: "destructive",
        title: "Signup Failed",
        description: `Error: ${error}`,
      });
    }
  };

  return { form, onSubmit };
};
