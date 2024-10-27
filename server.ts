import "dotenv/config";
import { Client } from "pg";
import { backOff } from "exponential-backoff";
import express from "express";
import waitOn from "wait-on";
import onExit from "signal-exit";
import cors from "cors";

// Add your routes here
const setupApp = (client: Client): express.Application => {
  const app: express.Application = express();

  app.use(cors());

  app.use(express.json());

  app.get("/examples", async (_req, res) => {
    const { rows } = await client.query(`SELECT * FROM example_table`);
    res.json(rows);
  });

  app.get("/margin-padding", async (_req, res) => {
    const { rows } = await client.query(`SELECT * FROM margin_padding_table`);
    res.json(rows);
  });

  app.put("/margin-padding/:id", async (req, res) => {
    const { id } = req.params; 
    const updatedData = req.body;
  
    // Construct the SQL UPDATE query with dynamic column names
    const query = `
      UPDATE margin_padding_table
      SET 
        margin_top = $1,
        margin_bottom = $2,
        margin_left = $3,
        margin_right = $4,
        padding_top = $5,
        padding_bottom = $6,
        padding_left = $7,
        padding_right = $8
      WHERE id = $9
      RETURNING *;  
    `;
  
    const values = [
      updatedData.margin_top,
      updatedData.margin_bottom,
      updatedData.margin_left,
      updatedData.margin_right,
      updatedData.padding_top,
      updatedData.padding_bottom,
      updatedData.padding_left,
      updatedData.padding_right,
      id, 
    ];
  
    try {
      const { rows } = await client.query(query, values);
      if (rows.length > 0) {
        res.json(rows[0]); 
      } else {
        res.status(404).json({ error: "Record not found" }); 
      }
    } catch (error) {
      console.error("Error updating record:", error);
      res.status(500).json({ error: "Database error" }); 
    }
  });
  

  return app;
};

// Waits for the database to start and connects
const connect = async (): Promise<Client> => {
  console.log("Connecting");
  const resource = `tcp:${process.env.PGHOST}:${process.env.PGPORT}`;
  console.log(`Waiting for ${resource}`);
  await waitOn({ resources: [resource] });
  console.log("Initializing client");
  const client = new Client();
  await client.connect();
  console.log("Connected to database");

  // Ensure the client disconnects on exit
  onExit(async () => {
    console.log("onExit: closing client");
    await client.end();
  });

  return client;
};

const main = async () => {
  const client = await connect();
  const app = setupApp(client);
  const port = parseInt(process.env.SERVER_PORT);
  app.listen(port, () => {
    console.log(
      `Draftbit Coding Challenge is running at http://localhost:${port}/`
    );
  });
};

main();
