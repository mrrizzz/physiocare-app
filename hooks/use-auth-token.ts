// hooks/useAuthToken.ts
import { useState, useEffect } from "react";
import { parseJWT } from "@/utils/jwt-decode";

interface UserData {
  // Sesuaikan dengan struktur data JWT Anda
  id?: string;
  email?: string;
  username?: string;
  role?: string;
  // ... properti lainnya
}

export function useAuthToken() {
  const [userData, setUserData] = useState<UserData | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const getIdFromToken = () => {
      try {
        const token = localStorage.getItem("token");
        if (!token) return null;
        return parseJWT(token);
      } catch (error) {
        console.error("Error parsing token:", error);
        return null;
      }
    };

    const data = getIdFromToken();
    setUserData(data);
    setLoading(false);
  }, []);

  return {
    userData,
    loading,
    isAuthenticated: !!userData,
  };
}
