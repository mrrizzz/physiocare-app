import { useRouter } from "next/navigation";
import { useToast } from "./use-toast";
import { LoginInput, LoginSchema } from "@/schema/auth";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";

export const useLoginForm = () => {
  const router = useRouter();
  const { toast } = useToast();

  const form = useForm<LoginInput>({
    resolver: zodResolver(LoginSchema),
    defaultValues: {
      email: "",
      password: "",
    },
  });

  const onSubmit = async (values: LoginInput) => {
    try {
      const response = await fetch("/api/auth/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(values),
      });

      console.log(response);

      const data = await response.json();

      console.log(data[0]);
      const { role } = data[0].payload;
      const token = data[0].token;

      console.log(role);
      console.log(token);

      if (response.ok) {
        localStorage.setItem("token", token);
        toast({
          title: "Login Successful",
          description: "You will be redirected to the dashboard",
        });
        router.push("/dashboard");
      } else {
        throw new Error(data.error);
      }
    } catch (error) {
      toast({
        variant: "destructive",
        title: "Login Failed",
        description: `Error: ${error}`,
      });
    }
  };
  return { form, onSubmit };
};
