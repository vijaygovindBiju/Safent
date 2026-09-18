/**
 * Travel SOS Mesh — Lightweight Cloud Emergency Ingest Backend
 * Team: Maravazha (Vijaygovind Biju, Noel Paul Tomy)
 * Challenge: SC-03 — Late-night journey safety companion
 *
 * Zero-dependency Node.js HTTP Server providing REST endpoints for:
 * - /api/health
 * - /api/journeys
 * - /api/incidents
 * - /api/incidents/:id/acknowledge
 * - /api/incidents/:id/resolve
 * - /api/mesh/relay
 */

const http = require('http');
const url = require('url');

const PORT = process.env.PORT || 3000;

// In-Memory Database for Hackathon Prototype
const database = {
  journeys: new Map(),
  incidents: new Map(),
  relayLogs: [],
};

// Seed sample responder console
const responderConsole = {
  id: 'CONSOLE_04',
  operator: 'Officer Radhakrishnan (Kochi Emergency Dispatch Desk #04)',
  status: 'ONLINE',
  activeUnits: ['Ambulance 108 - MG Road', 'Police Patrol Unit #04'],
};

function sendJson(res, statusCode, data) {
  res.writeHead(statusCode, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With',
  });
  res.end(JSON.stringify(data, null, 2));
}

function parseBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString();
    });
    req.on('end', () => {
      try {
        resolve(body ? JSON.parse(body) : {});
      } catch (err) {
        resolve({});
      }
    });
    req.on('error', reject);
  });
}

const server = http.createServer(async (req, res) => {
  const parsedUrl = url.parse(req.url, true);
  const path = parsedUrl.pathname;
  const method = req.method;

  // Handle CORS Preflight
  if (method === 'OPTIONS') {
    res.writeHead(204, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With',
    });
    res.end();
    return;
  }

  try {
    // 1. Health Check
    if (path === '/api/health' && method === 'GET') {
      return sendJson(res, 200, {
        status: 'ONLINE',
        system: 'Travel SOS Mesh Emergency Backend',
        version: '1.0.0',
        timestamp: new Date().toISOString(),
        responderConsole,
        stats: {
          activeJourneys: database.journeys.size,
          activeIncidents: database.incidents.size,
          meshRelayHops: database.relayLogs.length,
        },
      });
    }

    // 2. Journeys API
    if (path === '/api/journeys' && method === 'GET') {
      const all = Array.from(database.journeys.values());
      return sendJson(res, 200, { success: true, count: all.length, journeys: all });
    }

    if (path === '/api/journeys' && method === 'POST') {
      const body = await parseBody(req);
      const journeyId = body.id || `JNY-${Date.now().toString(36).toUpperCase()}`;
      const record = {
        ...body,
        id: journeyId,
        serverReceivedAt: new Date().toISOString(),
      };
      database.journeys.set(journeyId, record);
      return sendJson(res, 201, {
        success: true,
        message: 'Journey registered on cloud safety monitor',
        journey: record,
      });
    }

    // 3. Incidents API
    if (path === '/api/incidents' && method === 'GET') {
      const all = Array.from(database.incidents.values());
      return sendJson(res, 200, { success: true, count: all.length, incidents: all });
    }

    if (path === '/api/incidents' && method === 'POST') {
      const body = await parseBody(req);
      const incidentId = body.id || `INC-${Date.now().toString(36).toUpperCase()}`;
      const record = {
        ...body,
        id: incidentId,
        serverReceivedAt: new Date().toISOString(),
        status: body.status || 'SOS_RECEIVED',
      };
      database.incidents.set(incidentId, record);

      console.log(`[ALERT] Ingested Emergency SOS: ${incidentId} | Risk: ${body.riskScore}/100`);

      return sendJson(res, 201, {
        success: true,
        message: 'Distress beacon ingested into emergency dispatch queue',
        incident: record,
        dispatchStatus: 'DISPATCH_QUEUED',
      });
    }

    // 4. Acknowledge Incident API
    if (path.startsWith('/api/incidents/') && path.endsWith('/acknowledge') && method === 'POST') {
      const parts = path.split('/');
      const incidentId = parts[3];
      const body = await parseBody(req);

      let incident = database.incidents.get(incidentId);
      if (!incident) {
        // Create stub if ingested via offline mesh hop
        incident = {
          id: incidentId,
          status: 'ACKNOWLEDGED',
          acknowledgedBy: body.responder || responderConsole.operator,
          acknowledgedAt: new Date().toISOString(),
          responderNotes: body.notes || 'Emergency response units dispatched to coordinates.',
        };
      } else {
        incident.status = 'ACKNOWLEDGED';
        incident.acknowledgedBy = body.responder || responderConsole.operator;
        incident.acknowledgedAt = new Date().toISOString();
        incident.responderNotes = body.notes || 'Emergency response units dispatched to coordinates.';
      }
      database.incidents.set(incidentId, incident);

      return sendJson(res, 200, {
        success: true,
        message: 'Incident acknowledged by emergency response console',
        incident,
      });
    }

    // 5. Resolve Incident API
    if (path.startsWith('/api/incidents/') && path.endsWith('/resolve') && method === 'POST') {
      const parts = path.split('/');
      const incidentId = parts[3];
      const body = await parseBody(req);

      let incident = database.incidents.get(incidentId);
      if (!incident) {
        incident = { id: incidentId, status: 'RESOLVED' };
      }
      incident.status = 'RESOLVED';
      incident.resolvedAt = new Date().toISOString();
      incident.resolutionNotes = body.notes || 'Traveller confirmed safe. Case resolved.';
      database.incidents.set(incidentId, incident);

      return sendJson(res, 200, {
        success: true,
        message: 'Incident resolved and secured',
        incident,
      });
    }

    // 6. Mesh Relay Ingest API
    if (path === '/api/mesh/relay' && method === 'POST') {
      const body = await parseBody(req);
      const hopRecord = {
        relayId: `RELAY-${Date.now().toString(36).toUpperCase()}`,
        ...body,
        ingestedAt: new Date().toISOString(),
      };
      database.relayLogs.push(hopRecord);
      return sendJson(res, 200, {
        success: true,
        message: 'Store-and-forward mesh packet accepted at Internet Gateway',
        hopRecord,
      });
    }

    // 404 Not Found
    sendJson(res, 404, {
      error: 'Not Found',
      path,
      endpoints: [
        'GET /api/health',
        'GET/POST /api/journeys',
        'GET/POST /api/incidents',
        'POST /api/incidents/:id/acknowledge',
        'POST /api/incidents/:id/resolve',
        'POST /api/mesh/relay',
      ],
    });
  } catch (err) {
    console.error('Server error:', err);
    sendJson(res, 500, { error: 'Internal Server Error', message: err.message });
  }
});

server.listen(PORT, () => {
  console.log(`[Travel SOS Mesh Backend] Server listening on port ${PORT}`);
  console.log(`[Travel SOS Mesh Backend] Endpoints ready at http://localhost:${PORT}/api/health`);
});
