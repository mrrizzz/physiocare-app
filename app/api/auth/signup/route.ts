import { NextRequest } from "next/server";
import bcrypt from "bcryptjs";
import db from "@/lib/db";
import { formatResponse } from "@/utils/response-formatter";
import { handleError } from "@/utils/error-handling";

export async function POST(request: NextRequest) {
  try {
    const { username, email, password } = await request.json();

    const existingUser = await db.account.findFirst({
      where: {
        OR: [{ email }, { username }],
      },
    });

    if (existingUser) {
      throw new Error("User already exists");
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    return await db.$transaction(async (tx) => {
      const profile = await tx.profile.create({
        data: {
          name: username,
        },
      });

      const account = await tx.account.create({
        data: {
          email,
          password: hashedPassword,
          username,
          role: "PATIENT",
          profile_id: profile.id,
        },
        include: {
          profile: {
            select: {
              id: true,
              name: true,
              created_at: true,
            },
          },
        },
      });

      const { password: _, ...accountWithoutPassword } = account;
      return formatResponse(
        201,
        "Account created successfully",
        accountWithoutPassword
      );
    });
  } catch (error) {
    console.log(error);
    return handleError(error);
  }
}
