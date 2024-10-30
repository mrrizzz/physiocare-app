import { formatResponse } from "./response-formatter";

export const parseJWT = (token: string) => {
  try {
    const base64Url = token.split(".")[1];
    const base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
    const jsonPayload = decodeURIComponent(
      atob(base64)
        .split("")
        .map((c) => "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2))
        .join("")
    );
    return JSON.parse(jsonPayload);
  } catch (e) {
    return null;
  }
};

export const getTokenFromRequest = (req: Request) => {
  const authHeader = req.headers.get("Authorization");
  if (!authHeader) return formatResponse(401, "Unauthorized");

  const token = authHeader.split(" ")[1];
  if (!token) return formatResponse(401, "Invalid Token format");

  const tokenPayload = parseJWT(token);
  if (!tokenPayload) return formatResponse(401, "Invalid Token");

  return tokenPayload;
};
