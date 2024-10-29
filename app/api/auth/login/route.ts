/* eslint-disable @typescript-eslint/no-unused-vars */
import { NextRequest } from "next/server";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import db from "@/lib/db";
import { LoginSchema } from "@/schema/auth";
import { formatResponse } from "@/utils/response-formatter";
import { handleError } from "@/utils/error-handling";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { email, password } = LoginSchema.parse(body);

    const account = await db.account.findUnique({
      where: { email },
    });

    if (!account || !(await bcrypt.compare(password, account.password))) {
      return formatResponse(401, "Invalid email or password");
    }

    const payload = {
      id: account.id,
      email: account.email,
      role: account.role,
      username: account.username,
    };

    const secret = process.env.JWT_SECRET!;
    const expiresIn = "1d";
    const token = jwt.sign(payload, secret, { expiresIn });

    const { password: _, ...accountWithoutPassword } = account;

    return formatResponse(
      200,
      "Login successful",
      accountWithoutPassword,
      token
    );
  } catch (error) {
    return handleError(error);
  }
}
