import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function NotFound() {
  return (
    <div className="flex h-screen flex-col items-center justify-center">
      <h1 className="text-4xl font-bold">404</h1>
      <h2 className="mt-2 text-xl">Page Not Found</h2>
      <p className="mt-4 text-center text-muted-foreground">
        Sorry, we couldn't find the page you're looking for.
      </p>
      <Button asChild className="mt-8">
        <Link href="/dashboard">Return to Dashboard</Link>
      </Button>
    </div>
  );
}
