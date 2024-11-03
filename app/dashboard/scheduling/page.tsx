"use client";

import { useState, useEffect } from "react";
import { format } from "date-fns";
import { Calendar, Clock, User } from "lucide-react";
import { toast } from "@/hooks/use-toast";
import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";

interface Schedule {
  id: number;
  staff: { profile: { name: string } };
  service: { name: string };
  date: string;
  session: string;
  status: string;
}

export default function SchedulingPage() {
  const [schedules, setSchedules] = useState<Schedule[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [statusFilter, setStatusFilter] = useState<string | null>(null);

  useEffect(() => {
    async function fetchSchedules() {
      try {
        const response = await fetch("/api/scheduling", {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`, // Adjust this to how you store your auth token
          },
        });
        if (!response.ok) {
          throw new Error("Failed to fetch schedules");
        }
        const data = await response.json();
        console.log(data);
        setSchedules(data.data);
      } catch (error) {
        toast({
          title: "Error",
          description: "Failed to load schedules. Please try again later.",
          variant: "destructive",
        });
      } finally {
        setIsLoading(false);
      }
    }

    fetchSchedules();
  }, []);

  const filteredSchedules = statusFilter
    ? schedules.filter((schedule) => schedule.status === statusFilter)
    : schedules;

  const getStatusColor = (status: string) => {
    switch (status) {
      case "waiting":
        return "bg-yellow-500";
      case "scheduled":
        return "bg-green-500";
      case "completed":
        return "bg-green-800";
      case "cancelled":
        return "bg-red-500";
      default:
        return "bg-gray-500";
    }
  };

  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-screen">
        Loading...
      </div>
    );
  }

  return (
    <div className="container mx-auto py-10">
      <h1 className="text-3xl font-bold mb-6">My Schedules</h1>
      <div className="mb-4">
        <Select onValueChange={(value) => setStatusFilter(value || null)}>
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Filter by status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All</SelectItem>
            <SelectItem value="waiting">Waiting</SelectItem>
            <SelectItem value="scheduled">Scheduled</SelectItem>
            <SelectItem value="completed">Completed</SelectItem>
            <SelectItem value="cancelled">Cancelled</SelectItem>
          </SelectContent>
        </Select>
      </div>
      <Table>
        <TableCaption>A list of your scheduled appointments.</TableCaption>
        <TableHeader>
          <TableRow>
            <TableHead>Date</TableHead>
            <TableHead>Session</TableHead>
            <TableHead>Service</TableHead>
            <TableHead>Staff</TableHead>
            <TableHead>Status</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {filteredSchedules.map((schedule) => (
            <TableRow key={schedule.id}>
              <TableCell className="font-medium">
                <div className="flex items-center">
                  <Calendar className="mr-2 h-4 w-4" />
                  {format(new Date(schedule.date), "PPP")}
                </div>
              </TableCell>
              <TableCell>
                <div className="flex items-center">
                  <Clock className="mr-2 h-4 w-4" />
                  {schedule.session}
                </div>
              </TableCell>
              <TableCell>{schedule.service.name}</TableCell>
              <TableCell>
                <div className="flex items-center">
                  <User className="mr-2 h-4 w-4" />
                  {schedule.staff.profile.name}
                </div>
              </TableCell>
              <TableCell>
                <Badge className={getStatusColor(schedule.status)}>
                  {schedule.status}
                </Badge>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
