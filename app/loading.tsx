import { Loader2 } from "lucide-react";

export default function Loading() {
  return (
    <div className="h-screen flex justify-center items-center">
      <div className="text-center">
        <Loader2 className="mx-auto h-16 w-16 animate-spin text-primary" />
        <h2 className="mt-4 text-xl font-semibold">Loading...</h2>
        <p className="text-muted-foreground">Please wait...</p>
      </div>
    </div>
  );
}
