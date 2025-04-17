import pandas as pd
from flask import Flask, request, jsonify
from pyspark.sql import SparkSession
from pyspark.ml import PipelineModel

app = Flask(__name__)

# Start Spark session
spark = SparkSession.builder.appName("FlightAPI").getOrCreate()

# Load your saved model (upload this folder to Render too)
model_path = "flight_fare_gbt_model"
model = PipelineModel.load(model_path)

@app.route('/')
def home():
    return jsonify({"message": "Flight Price API is running!"})
@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    df = pd.DataFrame([data])
    spark_df = spark.createDataFrame(df)
    prediction = model.transform(spark_df).select("prediction").collect()[0][0]
    return jsonify({"predicted_fare": float(prediction)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
