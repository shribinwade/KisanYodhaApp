const express = require('express');
const multer = require('multer');
const XLSX = require('xlsx');
const { Pool } = require('pg');
const cors = require('cors'); // Import cors
const bcrypt = require('bcrypt');

const app = express();
app.use(cors()); // Enable CORS for all origins
app.use(express.json());

const upload = multer({ dest: 'uploads/' });

// PostgreSQL connection pool setup
const pool = new Pool({
  host: '34.71.87.187',
  port: 5432,
  database: 'datagovernance',
  user: 'postgres',
  password: 'India@5555',
});

// Register user with email check and encrypted password
app.post('/black_ox_api/register', async (req, res) => {
  const { name, password, email, number,image_url } = req.body;

  try {
    const client = await pool.connect();

    // Check if the email already exists
    const emailCheck = await client.query('SELECT COUNT(*) FROM public.black_ox_user WHERE email = $1', [email]);

    if (emailCheck.rows[0].count > 0) {
      // If the email exists, return an error
      client.release();
      return res.status(400).json({ success: false, message: 'Email already exists' });
    }

    // Hash the password before storing
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    // Insert the new user into the database
    await client.query(
      'INSERT INTO public.black_ox_user (name, password, email, number,image_url) VALUES ($1, $2, $3, $4, $5)',
      [name, hashedPassword, email, number,image_url]
    );

    client.release();
    res.status(200).json({ success: true, message: 'User registered successfully' });
  } catch (err) {
    console.error('Error registering user:', err);
    res.status(500).json({ success: false, message: 'Registration failed' });
  }
});

// Login route
app.post('/black_ox_api/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const client = await pool.connect();

    // Fetch the user by email
    const result = await client.query('SELECT password FROM public.black_ox_user WHERE email = $1', [email]);

    client.release();

    if (result.rows.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid email or password' });
    }

    const hashedPassword = result.rows[0].password;

    // Compare the hashed password with the provided password
    const passwordMatch = await bcrypt.compare(password, hashedPassword);

    if (passwordMatch) {
      res.status(200).json({ success: true, message: 'Login successful' });
    } else {
      res.status(401).json({ success: false, message: 'Invalid email or password' });
    }
  } catch (err) {
    console.error('Error logging in:', err);
    res.status(500).json({ success: false, message: 'Login failed' });
  }
});

// Fetch user data route
app.get('/black_ox_api/user-data', async (req, res) => {
  const { email } = req.query;

  try {
    const result = await pool.query(
      'SELECT * FROM public.black_ox_user WHERE email = $1',
      [email]
    );

    if (result.rows.length > 0) {
      res.status(200).json({ success: true, data: result.rows });
    } else {
      res.status(404).json({ success: false, message: 'User not found' });
    }
  } catch (err) {
    console.error('Error executing query', err.stack);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// Fetch user data route
app.get('/black_ox_api/advisory_details', async (req, res) => {
  const { email } = req.query;

  try {
    const result = await pool.query(
      'SELECT * FROM public.black_ox_advisor_details',
    );

    if (result.rows.length > 0) {
      res.status(200).json({ success: true, data: result.rows });
    } else {
      res.status(404).json({ success: false, message: 'Advisory not found' });
    }
  } catch (err) {
    console.error('Error executing query', err.stack);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});



//Upload Crop Bill of Material
app.post('/black_ox_api/upload/agri_crop_bill_of_material', upload.single('file'), (req, res) => {
  const file = req.file;

  // Parse Excel file
  const workbook = XLSX.readFile(file.path);
  const sheetName = workbook.SheetNames[0];
  const worksheet = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName]);

  // Insert data into PostgreSQL
  worksheet.forEach(async (row) => {
    const { croptype, crop, cropunitarea, cropuom, bomid, bomcode, totalamt, subsidypercent, subsidyamt, tax1percentage, tax1amount, tax2percentage, tax2amount, tax3percentage, tax3amount, sellingrate, qtyproduced, qtyuom, totalsaleqty, profit } = row;
    try {
      await pool.query(
              'INSERT INTO agri_crop_bill_of_material (croptype, crop, cropunitarea, cropuom, bomid, bomcode, totalamt, subsidypercent, subsidyamt, tax1percentage, tax1amount, tax2percentage, tax2amount, tax3percentage, tax3amount, sellingrate, qtyproduced, qtyuom, totalsaleqty, profit) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20)',
              [croptype, crop, cropunitarea, cropuom, bomid, bomcode, totalamt, subsidypercent, subsidyamt, tax1percentage, tax1amount, tax2percentage, tax2amount, tax3percentage, tax3amount, sellingrate, qtyproduced, qtyuom, totalsaleqty, profit]
            );
          } catch (error) {
            console.error(error);
          }
        });
  res.send('File uploaded and data stored in the database.');
});
//agri_crop_bill_of_material_detail
app.post('/black_ox_api/upload/agri_crop_bill_of_material_detail', upload.single('file'), (req, res) => {
  const file = req.file;

  // Parse Excel file
  const workbook = XLSX.readFile(file.path);
  const sheetName = workbook.SheetNames[0];
  const worksheet = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName]);

  // Insert data into PostgreSQL
  worksheet.forEach(async (row) => {
    const { bomid, bomcode, item_category, item_name, quantity, rate_per_unit, uom, total_cost, subsidyamount, tax1amount, tax2amount, tax3amount, tax1percent, tax2percent, tax3percent } = row;
    try {
      await pool.query(
              'INSERT INTO agri_crop_bill_of_material_detail (bomid, bomcode, item_category, item_name, quantity, rate_per_unit, uom, total_cost, subsidyamount, tax1amount, tax2amount, tax3amount, tax1percent, tax2percent, tax3percent) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)',
              [bomid, bomcode, item_category, item_name, quantity, rate_per_unit, uom, total_cost, subsidyamount, tax1amount, tax2amount, tax3amount, tax1percent, tax2percent, tax3percent]
            );
          } catch (error) {
            console.error(error);
          }
        });
  res.send('File uploaded and data stored in the database.');
});
 // Upload agri_data_image
 app.post('/black_ox_api/upload/agri_data_image', upload.single('file'), (req, res) => {
   const file = req.file;

   // Parse Excel file
   const workbook = XLSX.readFile(file.path);
   const sheetName = workbook.SheetNames[0];
   const worksheet = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName]);

   // Insert data into PostgreSQL
   worksheet.forEach(async (row) => {
     const { datatype, dataimage, bomid, bomcode } = row;
     try {
       await pool.query(
               'INSERT INTO agri_data_image ( datatype, dataimage, bomid, bomcode) VALUES ($1, $2, $3,$4)',
               [ datatype, dataimage, bomid, bomcode]
             );
           } catch (error) {
             console.error(error);
           }
         });
   res.send('File uploaded and data stored in the database.');
 });
// Upload Season
app.post('/black_ox_api/upload/agri_season', upload.single('file'), (req, res) => {
  const file = req.file;

  // Parse Excel file
  const workbook = XLSX.readFile(file.path);
  const sheetName = workbook.SheetNames[0];
  const worksheet = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName]);

  // Insert data into PostgreSQL
  worksheet.forEach(async (row) => {
    const { country,state,district,taluka,pincode,gps,croptype,crop,seasonid,seasoncode } = row;
    try {
      await pool.query(
              'INSERT INTO agri_season (country,state,district,taluka,pincode,gps,croptype,crop,seasonid,seasoncode) VALUES ($1, $2, $3,$4, $5, $6, $7, $8, $9, $10)',
              [country,state,district,taluka,pincode,gps,croptype,crop,seasonid,seasoncode]
            );
          } catch (error) {
            console.error(error);
          }
        });
  res.send('File uploaded and data stored in the database.');
});
//agri_soil_information
app.post('/black_ox_api/upload/agri_soil_information', upload.single('file'), (req, res) => {
  const file = req.file;

  // Parse Excel file
  const workbook = XLSX.readFile(file.path);
  const sheetName = workbook.SheetNames[0];
  const worksheet = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName]);

  // Insert data into PostgreSQL
  worksheet.forEach(async (row) => {
    const { country, state, district, taluka, pincode, n, p, k, soiltype, soilname, soilid, season, croptype, cropcultivated, gps, fertilizertype, fertilizer, diseasetype, disease, mastersoilid, soilcode } = row;
    try {
      await pool.query(
              'INSERT INTO agri_soil_information (country, state, district, taluka, pincode, n, p, k, soiltype, soilname, soilid, season, croptype, cropcultivated, gps, fertilizertype, fertilizer, diseasetype, disease, mastersoilid, soilcode) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21)',
              [country, state, district, taluka, pincode, n, p, k, soiltype, soilname, soilid, season, croptype, cropcultivated, gps, fertilizertype, fertilizer, diseasetype, disease, mastersoilid, soilcode]
            );
          } catch (error) {
            console.error(error);
          }
        });
  res.send('File uploaded and data stored in the database.');
});
//Upload User Bill of Material
app.post('/black_ox_api/upload/agri_user_bill_of_material', upload.single('file'), (req, res) => {
  const file = req.file;

  // Parse Excel file
  const workbook = XLSX.readFile(file.path);
  const sheetName = workbook.SheetNames[0];
  const worksheet = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName]);

  // Insert data into PostgreSQL
  worksheet.forEach(async (row) => {
    const { userid, bomid, bomcode, seasonid, cropunitarea, cropupm, totalamount, subsidy, tax1amount, tax2amount, tax3amount, sales_fields } = row;
    try {
      await pool.query(
              'INSERT INTO agri_user_bill_of_material (userid, bomid, bomcode, seasonid, cropunitarea, cropupm, totalamount, subsidy, tax1amount, tax2amount, tax3amount, sales_fields) VALUES ($1, $2, $3,$4, $5, $6, $7, $8, $9, $10, $11, $12)',
              [userid, bomid, bomcode, seasonid, cropunitarea, cropupm, totalamount, subsidy, tax1amount, tax2amount, tax3amount, sales_fields]
            );
          } catch (error) {
            console.error(error);
          }
        });
  res.send('File uploaded and data stored in the database.');
});
//agri_user_bill_of_material_detail
app.post('/black_ox_api/upload/agri_user_bill_of_material_detail', upload.single('file'), (req, res) => {
  const file = req.file;

  // Parse Excel file
  const workbook = XLSX.readFile(file.path);
  const sheetName = workbook.SheetNames[0];
  const worksheet = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName]);

  // Insert data into PostgreSQL
  worksheet.forEach(async (row) => {
    const { userid, bomid, bomcode, seasonid, item_category, item_name, qty, rate, uom, total_cost, subsidy, tax1amount, tax2amount, tax3amount } = row;
    try {
      await pool.query(
              'INSERT INTO agri_user_bill_of_material_detail (userid, bomid, bomcode, seasonid, item_category, item_name, qty, rate, uom, total_cost, subsidy, tax1amount, tax2amount, tax3amount) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)',
              [userid, bomid, bomcode, seasonid, item_category, item_name, qty, rate, uom, total_cost, subsidy, tax1amount, tax2amount, tax3amount]
            );
          } catch (error) {
            console.error(error);
          }
        });
  res.send('File uploaded and data stored in the database.');
});
// agri_user_soil_information
app.post('/black_ox_api/upload/agri_user_soil_information', upload.single('file'), (req, res) => {
  const file = req.file;

  // Parse Excel file
  const workbook = XLSX.readFile(file.path);
  const sheetName = workbook.SheetNames[0];
  const worksheet = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName]);

  // Insert data into PostgreSQL
  worksheet.forEach(async (row) => {
    const { userid, soilid, country, state, district, taluka, pincode, n, p, k, soiltype, soilname, season, croptype, cropcultivated, gps, fertilizertype, fertilizer, diseasetype, disease, mastersoilid, soilcode } = row;
    try {
      await pool.query(
              'INSERT INTO agri_user_soil_information (userid, soilid, country, state, district, taluka, pincode, n, p, k, soiltype, soilname, season, croptype, cropcultivated, gps, fertilizertype, fertilizer, diseasetype, disease, mastersoilid, soilcode) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22)',
              [userid, soilid, country, state, district, taluka, pincode, n, p, k, soiltype, soilname, season, croptype, cropcultivated, gps, fertilizertype, fertilizer, diseasetype, disease, mastersoilid, soilcode]
            );
          } catch (error) {
            console.error(error);
          }
        });
  res.send('File uploaded and data stored in the database.');
});
// agri_weather_information
app.post('/black_ox_api/upload/agri_weather_information', upload.single('file'), (req, res) => {
  const file = req.file;

  // Parse Excel file
  const workbook = XLSX.readFile(file.path);
  const sheetName = workbook.SheetNames[0];
  const worksheet = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName]);

  // Insert data into PostgreSQL
  worksheet.forEach(async (row) => {
    const { year, month, temperature, pressure, humidity, windspeed, rainfall, viscosity, country, state, district, taluka, pincode, gps } = row;
    try {
      await pool.query(
              'INSERT INTO agri_weather_information (year, month, temperature, pressure, humidity, windspeed, rainfall, viscosity, country, state, district, taluka, pincode, gps) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)',
              [year, month, temperature, pressure, humidity, windspeed, rainfall, viscosity, country, state, district, taluka, pincode, gps]
            );
          } catch (error) {
            console.error(error);
          }
        });
  res.send('File uploaded and data stored in the database.');
});
//fetch data
app.get('/black_ox_api/data/:table', async (req, res) => {
  const table = req.params.table;
  try {
    const columns = await pool.query(`SELECT column_name FROM information_schema.columns WHERE table_name = $1`, [table]);
    const rows = await pool.query(`SELECT * FROM ${table}`);
    res.json({ columns: columns.rows.map(row => row.column_name), rows: rows.rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
//Update the Data
app.put('/black_ox_api/update/:table/:id', async (req, res) => {
    const table = req.params.table;
    const id = req.params.id;
    const data = req.body;

    console.log(`Updating data for ${table} with ID ${id}`);
    console.log(`Data received:`, data);

    try {
        // Check if the ID exists
        const checkQuery = `SELECT COUNT(*) FROM ${table} WHERE id = $1::int`;
        const checkResult = await pool.query(checkQuery, [id]);
        const idExists = checkResult.rows[0].count > 0;

        if (!idExists) {
            return res.status(400).json({ error: 'ID does not exist' });
        }

        // Construct the SET clause of the UPDATE query
        let setString = '';
        const values = [];
        let valueIndex = 1;

        for (let column in data) {
            console.log(`Processing column: ${column}, value: ${data[column]}`);
            if (column !== 'id') {
                setString += `${column} = $${valueIndex}, `;
                values.push(data[column]);
                valueIndex++;
            }
        }

        // Check if setString has any data
        if (setString.length === 0) {
            return res.status(400).json({ error: 'No data provided to update' });
        }

        // Remove trailing comma and space
        setString = setString.slice(0, -2);
        values.push(id);

        // Construct the full update query
        const updateQuery = `UPDATE ${table} SET ${setString} WHERE id = $${valueIndex}`;

        console.log(`Update Query: ${updateQuery}`);
        console.log(`Values:`, values);

        // Execute the update query
        await pool.query(updateQuery, values);

        res.status(200).json({ message: 'Data updated successfully' });
    } catch (err) {
        console.error(`Error updating data:`, err);
        res.status(500).json({ error: `Failed to update data: ${err.message}` });
    }
});

// Route to get business details
app.get('/black_ox_api/businessDetails', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM public.business_details');
    const rows = result.rows;
    res.json(rows);
  } catch (error) {
    console.error('Error fetching business details:', error);
    res.status(500).json({ error: 'Failed to fetch business details' });
  }
});

// Route to get category types
app.get('/black_ox_api/categoryTypes', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM public.category_master');
    const rows = result.rows;
    res.json(rows);
  } catch (error) {
    console.error('Error fetching category types:', error);
    res.status(500).json({ error: 'Failed to fetch category types' });
  }
});

app.get('/black_ox_api/bom/:bomcode/:bomid', async (req, res) => {
  const { bomcode, bomid } = req.params;

  try {
    const result = await pool.query(
      'SELECT * FROM agri_crop_bill_of_material_detail WHERE bomcode = $1 AND bomid = $2',
      [bomcode, bomid]
    );
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).send('Server Error');
  }
});
app.get('/black_ox_api/getUnit/:bomcode/:bomid', async (req, res) => {
  const { bomcode, bomid } = req.params;

  try {
    const result = await pool.query(
      'SELECT * FROM agri_crop_bill_of_material WHERE bomcode = $1 AND bomid = $2',
      [bomcode, bomid]
    );
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).send('Server Error');
  }
});
app.get('/black_ox_api/crop_details', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM agri_crop_bill_of_material',
    );
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).send('Server Error');
  }
});

// Endpoint to get soil types based on location
app.post('/black_ox_api/getSoilTypes', async (req, res) => {
  const { country, state, district, taluka } = req.body;

  try {
    const query = 'SELECT DISTINCT soiltype FROM public.agri_soil_information WHERE country = $1 AND state = $2 AND district = $3 AND taluka = $4 ';

    const values = [country, state, district, taluka];

    const result = await pool.query(query, values);
    const soilTypes = result.rows.map(row => row.soiltype);

    res.status(200).json(soilTypes);
  } catch (error) {
    console.error('Error fetching soil types:', error);
    res.status(500).send('Server error');
  }
});

// Endpoint to get crop categories based on location and soil type
app.post('/black_ox_api/getCropCategories', async (req, res) => {
  const { country, state, district, taluka, soilType } = req.body;

  try {
    const query = 'SELECT DISTINCT croptype FROM public.agri_soil_information WHERE country = $1 AND state = $2 AND district = $3 AND taluka = $4 AND soiltype = $5';

    const values = [country, state, district, taluka, soilType];

    const result = await pool.query(query, values);
    const categories = result.rows.map(row => row.croptype);

    res.status(200).json(categories);
  } catch (error) {
    console.error('Error fetching crop categories:', error);
    res.status(500).send('Server error');
  }
});
app.post('/black_ox_api/getCrops', async (req, res) => {
  const { country, state, district, taluka, soilType, cropCategory } = req.body;

  try {
    const query = 'SELECT DISTINCT cropcultivated, soilcode FROM public.agri_soil_information WHERE country = $1 AND state = $2 AND district = $3 AND taluka = $4 AND soiltype = $5 AND croptype = $6';

    const values = [country, state, district, taluka, soilType, cropCategory];

    const result = await pool.query(query, values);
    const crops = result.rows.map(row => row.cropcultivated);

    res.status(200).json(result.rows);
  } catch (error) {
    console.error('Error fetching crops:', error);
    res.status(500).send('Server error');
  }
});




app.get('/black_ox_api/bom/:soilcode', async (req, res) => {
  const { soilcode } = req.params;

  try {
    // Query to fetch bomid and bomcode by soilcode
    const result = await pool.query(
      'SELECT bomid, bomcode,crop FROM agri_crop_bill_of_material WHERE soilcode = $1',
      [soilcode]
    );

    if (result.rows.length > 0) {
      res.status(200).json(result.rows[0]); // Return the first matching record
    } else {
      res.status(404).json({ error: 'No BOM found for the provided soil code.' });
    }
  } catch (error) {
    console.error('Error fetching BOM details:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Fetch Crops
app.get('/black_ox_api/allcrops', async (req, res) => {
  try {
    const result = await pool.query('SELECT DISTINCT name FROM public.crop ORDER BY name ASC');

    const crops = result.rows.map(row => row.name);
    res.json(crops);
   
  } catch (error) {
    console.error('Error fetching crops:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

//Fetch All States
app.get('/black_ox_api/allstates', async (req, res) => {
  try {
    const result = await pool.query('SELECT DISTINCT name FROM public.state');

    const crops = result.rows.map(row => row.name);
    res.json(crops);
   
  } catch (error) {
    console.error('Error fetching states:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Fetch Seasons
app.get('/black_ox_api/allseasons', async (req, res) => {
  try {
    const result = await pool.query('SELECT DISTINCT name FROM public.season');
    const seasons = result.rows.map(row => row.name);
    res.json(seasons);
  } catch (error) {
    console.error('Error fetching seasons:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Fetch Countries
app.get('/black_ox_api/countries', async (req, res) => {
  try {
    const result = await pool.query('SELECT DISTINCT country FROM public.agri_soil_information');
    const countries = result.rows.map(row => row.country);
    res.json(countries);
  } catch (error) {
    console.error('Error fetching countries:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});




// Fetch States by Country
app.get('/black_ox_api/states/:country', async (req, res) => {
  const country = req.params.country;
  try {
    const result = await pool.query('SELECT DISTINCT state FROM public.agri_soil_information WHERE country = $1', [country]);
    const states = result.rows.map(row => row.state);
    res.json(states);
  } catch (error) {
    console.error('Error fetching states:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Fetch Districts by State
app.get('/black_ox_api/districts/:state', async (req, res) => {
  const state = req.params.state;
  try {
    const result = await pool.query('SELECT DISTINCT district FROM public.agri_soil_information WHERE state = $1', [state]);
    const districts = result.rows.map(row => row.district);
    res.json(districts);
  } catch (error) {
    console.error('Error fetching districts:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Fetch Talukas by District
app.get('/black_ox_api/talukas/:district', async (req, res) => {
  const district = req.params.district;
  try {
    const result = await pool.query('SELECT DISTINCT taluka FROM public.agri_soil_information WHERE district = $1', [district]);
    const talukas = result.rows.map(row => row.taluka);
    res.json(talukas);
  } catch (error) {
    console.error('Error fetching talukas:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.post('/black_ox_api/registerBusiness', async (req, res) => {
  const {
    uName,
    uNumber,
    uEmail,
    bName,
    bAddress,
    bPinCode,
    bCity,
    gstNO,
    categoryType,
    productName,
    rate,
    ratePer,
    discountRate,
    startDate,
    endDate,
    registerDate,
    imageUrl
  } = req.body;

  try {
    // Insert business details into the database
    const result = await pool.query(
      'INSERT INTO public.business_details (u_name, u_number, u_email, b_name, b_address, b_pincode, b_city, gstno, category_type, product_name, rate, rate_per, discount_rate, start_date, end_date, register_date, image_url) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)',
      [
        uName,
        uNumber,
        uEmail,
        bName,
        bAddress,
        bPinCode,
        bCity,
        gstNO,
        categoryType,
        productName,
        rate,
        ratePer,
        discountRate,
        startDate,
        endDate,
        registerDate,
        imageUrl
      ]
    );

    res.status(200).json({ success: true, message: 'Business registered successfully!' });
  } catch (error) {
    console.error('Error inserting business details:', error);
    res.status(500).json({ success: false, message: 'Failed to register business details' });
  }
});

// Fetch crop data with price history
app.get('/black_ox_api/cropDataWithPriceHistory', async (req, res) => {
  console.log('GET API called with query params:', req.query);
  
  const { crop_name, year, state, season_name, country } = req.query;
  console.log('Extracted parameters:', {
    crop_name,
    year,
    state,
    season_name,
    country
  });

  try {
    const query = `
      SELECT * FROM cropDataWithPricHistoryUpdated
      WHERE crop_name = $1
      AND year = $2
      AND state = $3
      AND season_name = $4
      AND country = $5
      ORDER BY price_history_id ASC
    `;

    const values = [crop_name, year, state, season_name, country];
    console.log('Executing query:', query);
    console.log('With values:', values);

    const result = await pool.query(query, values);
    const rows = result.rows;
    console.log('Query result:', rows);

    if (rows.length === 0) {
      console.log('No data found for the given parameters');
      return res.status(404).json({ success: false, message: 'No data found for the specified parameters' });
    }

    // Extract crop info from the first row (since it's repeated)
    const {
      price_history_id,
      crop_name: cropName,
      season_name: seasonName,
      year: cropYear,
      month,
      price_per_unit,
      unit,
      currency,
      country: cropCountry,
      state: cropState,
      soil_type,
      crop_category,
      crop_variety,
      price_currency,
      sowing_period,
      current_market_price,
      predicted_market_price,
      market_price_unit,
      best_selling_market,
      msp_price,
      predicted_harvest_month,
      weather_impact,
      sowing_recommendations,
      ideal_soil_quality,
      ideal_weather_conditions
    } = rows[0];

    const crop_info = {
      price_history_id,
      crop_name: cropName,
      season_name: seasonName,
      year: cropYear,
      month,
      price_per_unit,
      unit,
      currency,
      country: cropCountry,
      state: cropState,
      soil_type,
      crop_category,
      crop_variety,
      price_currency,
      sowing_period,
      current_market_price,
      predicted_market_price,
      market_price_unit,
      best_selling_market,
      msp_price,
      predicted_harvest_month,
      weather_impact,
      sowing_recommendations,
      ideal_soil_quality,
      ideal_weather_conditions
    };

    // Build price history list
    const price_history = rows.map(row => ({
      price_history_id: row.price_history_id,
      price_per_unit: row.price_per_unit,
      month: row.month,
      year: row.year
    }));
    
    res.status(200).json({
      success: true,
      data: {
        crop_info,
        price_history
      }
    });

  } catch (error) {
    console.error('Error in cropDataWithPriceHistory API:', error);
    console.error('Error stack:', error.stack);
    res.status(500).json({ 
      success: false, 
      message: 'Failed to fetch crop data',
      error: error.message 
    });
  }
});

// Add POST endpoint to handle frontend requests
app.post('/black_ox_api/cropDataWithPriceHistory', async (req, res) => {
  console.log('POST API called with body:', req.body);
  
  const { crop_name, year, state, season_name, country } = req.body;
  console.log('Extracted parameters:', {
    crop_name,
    year,
    state,
    season_name,
    country
  });

  try {
    // Extract year from the date string if it's in ISO format
    const yearValue = year.includes('T') ? new Date(year).getFullYear().toString() : year;

    const query = `
      SELECT * FROM cropDataWithPricHistoryUpdated 
      WHERE crop_name = $1
      AND year = $2
      AND state = $3
      AND season_name = $4
      AND country = $5
      ORDER BY price_history_id ASC
    `;

    const values = [crop_name, yearValue, state, season_name, country];
    console.log('Executing query:', query);
    console.log('With values:', values);

    const result = await pool.query(query, values);
    const rows = result.rows;
    console.log('Query result:', rows);

    if (rows.length === 0) {
      console.log('No data found for the given parameters');
      return res.status(404).json({ success: false, message: 'No data found for the specified parameters' });
    }

    // Extract crop info from the first row (since it's repeated)
    const {
      price_history_id,
      crop_name: cropName,
      season_name: seasonName,
      year: cropYear,
      month,
      price_per_unit,
      unit,
      currency,
      country: cropCountry,
      state: cropState,
      soil_type,
      crop_category,
      crop_variety,
      price_currency,
      sowing_period,
      current_market_price,
      predicted_market_price,
      market_price_unit,
      best_selling_market,
      msp_price,
      predicted_harvest_month,
      weather_impact,
      sowing_recommendations,
      ideal_soil_quality,
      ideal_weather_conditions
    } = rows[0];

    const crop_info = {
      price_history_id,
      crop_name: cropName,
      season_name: seasonName,
      year: cropYear,
      month,
      price_per_unit,
      unit,
      currency,
      country: cropCountry,
      state: cropState,
      soil_type,
      crop_category,
      crop_variety,
      price_currency,
      sowing_period,
      current_market_price,
      predicted_market_price,
      market_price_unit,
      best_selling_market,
      msp_price,
      predicted_harvest_month,
      weather_impact,
      sowing_recommendations,
      ideal_soil_quality,
      ideal_weather_conditions
    };

    // Build price history list
    const price_history = rows.map(row => ({
      price_history_id: row.price_history_id,
      price_per_unit: row.price_per_unit,
      month: row.month,
      year: row.year
    }));
    
    res.status(200).json({
      success: true,
      data: {
        crop_info,
        price_history
      }
    });

  } catch (error) {
    console.error('Error in cropDataWithPriceHistory API:', error);
    console.error('Error stack:', error.stack);
    res.status(500).json({ 
      success: false, 
      message: 'Failed to fetch crop data',
      error: error.message 
    });
  }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});