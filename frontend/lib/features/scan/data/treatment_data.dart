class TreatmentProtocol {
  final String directTreatment;
  final String preventiveMeasures;
  final String fertilizersPesticides;

  const TreatmentProtocol({
    required this.directTreatment,
    required this.preventiveMeasures,
    required this.fertilizersPesticides,
  });
}

const Map<String, TreatmentProtocol> treatmentMap = {
  'healthy': TreatmentProtocol(
    directTreatment: 'Crop displays optimal structure. Maintain current watering and fertilizing cycles.',
    preventiveMeasures: 'Maintain steady crop rotation intervals and perform regular soil pH testing.',
    fertilizersPesticides: 'Standard organic NPK compost (10-10-10) during active growth states.'
  ),
  'scab': TreatmentProtocol(
    directTreatment: 'Apply lime sulfur or captan fungicides. Rake and destroy fallen leaves.',
    preventiveMeasures: 'Prune trees to keep the canopy open and allow leaves to dry quickly after rain.',
    fertilizersPesticides: 'Apply copper-based fungicides or sulfur sprays at 10-day intervals. Avoid heavy nitrogen.'
  ),
  'black rot': TreatmentProtocol(
    directTreatment: 'Prune infected tissue. Apply copper fungicide. Ensure good air circulation.',
    preventiveMeasures: 'Sanitize tools between cuts. Keep plants spaced appropriately.',
    fertilizersPesticides: 'Apply systemic fungicides during pre-bloom and post-bloom intervals.'
  ),
  'cedar rust': TreatmentProtocol(
    directTreatment: 'Remove nearby juniper hosts. Apply fungicide during wet spells.',
    preventiveMeasures: 'Plant rust-resistant cultivars and clean debris around orchards.',
    fertilizersPesticides: 'Use preventive sterol-inhibitor fungicides at tight cluster and petal fall stages.'
  ),
  'powdery mildew': TreatmentProtocol(
    directTreatment: 'Apply sulfur or potassium bicarbonate. Improve air circulation. Avoid overhead watering.',
    preventiveMeasures: 'Keep humidity low. Prune infected stems to improve sunlight penetration.',
    fertilizersPesticides: 'Apply organic neem oil or sulfur-based biological fungicides at weekly intervals.'
  ),
  'late blight': TreatmentProtocol(
    directTreatment: 'Apply copper fungicides immediately. Prune lower infected leaves. Keep foliage dry.',
    preventiveMeasures: 'Isolate crop beds from neighboring rows to mitigate fungal spore transfers.',
    fertilizersPesticides: 'Apply mancozeb or copper-based treatments. Avoid nitrogen-heavy fertilizers during outbreaks.'
  ),
  'early blight': TreatmentProtocol(
    directTreatment: 'Apply chlorothalonil or copper fungicide. Mulch to reduce soil splash. Rotate crops.',
    preventiveMeasures: 'Stake plants to keep leaves off the ground and water at the base only.',
    fertilizersPesticides: 'Incorporate potassium-rich organic fertilizers to build crop resistance.'
  ),
  'common rust': TreatmentProtocol(
    directTreatment: 'Apply sulfur or copper fungicides. Destroy infected crop residues post-harvest.',
    preventiveMeasures: 'Use resistant hybrid seed varieties and rotate crops with non-grasses.',
    fertilizersPesticides: 'Foliar application of strobilurin-class fungicides under high-humidity conditions.'
  ),
  'gray leaf spot': TreatmentProtocol(
    directTreatment: 'Rotate crops. Apply fungicide at first symptoms. Till under residue.',
    preventiveMeasures: 'Avoid conservation tillage in fields with a history of leaf spot infections.',
    fertilizersPesticides: 'Apply triazole-based systemic fungicides during early vegetative stages.'
  ),
  'northern leaf blight': TreatmentProtocol(
    directTreatment: 'Use resistant hybrids. Apply fungicide when lesions appear on lower leaves.',
    preventiveMeasures: 'Manage residue decomposition through fall tillage and rotate crops.',
    fertilizersPesticides: 'Use strobilurin or triazole fungicides during tasseling and silking intervals.'
  ),
  'leaf blight': TreatmentProtocol(
    directTreatment: 'Remove infected leaves. Apply copper-based fungicide. Avoid overhead irrigation.',
    preventiveMeasures: 'Clean garden debris thoroughly before planting next season.',
    fertilizersPesticides: 'Apply copper fungicides or bio-fungicides to protect newly emerged leaves.'
  ),
  'black measles': TreatmentProtocol(
    directTreatment: 'Prune affected canes. Apply fungicide. Reduce stress with proper irrigation.',
    preventiveMeasures: 'Protect pruning wounds with wound sealants to prevent fungal entry.',
    fertilizersPesticides: 'Apply liquid lime sulfur sprays during the dormant winter period.'
  ),
  'bacterial spot': TreatmentProtocol(
    directTreatment: 'Apply copper spray. Remove infected leaves. Avoid working wet plants.',
    preventiveMeasures: 'Use certified disease-free seeds and sanitize stakes/cages annually.',
    fertilizersPesticides: 'Use fixed copper sprays mixed with mancozeb to increase bactericidal efficacy.'
  ),
  'huanglongbing': TreatmentProtocol(
    directTreatment: 'Remove infected trees. Control psyllid vectors with insecticides. No cure available.',
    preventiveMeasures: 'Use insect nets for nurseries and plant only certified disease-free rootstock.',
    fertilizersPesticides: 'Apply systemic insecticides (neonicotinoids) to control the Asian citrus psyllid.'
  ),
  'leaf mold': TreatmentProtocol(
    directTreatment: 'Improve ventilation. Reduce humidity. Apply fungicide to lower leaves.',
    preventiveMeasures: 'Maintain greenhouse temperature above 15°C and ensure horizontal fans are active.',
    fertilizersPesticides: 'Apply preventive chlorothalonil or copper fungicides to prevent spore germination.'
  ),
  'septoria leaf spot': TreatmentProtocol(
    directTreatment: 'Apply fungicide. Remove lower infected leaves. Stake plants for airflow.',
    preventiveMeasures: 'Apply straw or plastic mulch to prevent fungal spores from splashing onto foliage.',
    fertilizersPesticides: 'Use chlorothalonil or copper fungicides. Support crop with organic compost tea.'
  ),
  'spider mites': TreatmentProtocol(
    directTreatment: 'Apply miticide or neem oil. Increase humidity. Introduce predatory mites.',
    preventiveMeasures: 'Spray foliage with water to wash off dust and discourage mite nesting.',
    fertilizersPesticides: 'Apply insecticidal soap or neem oil. Avoid broad-spectrum insecticides that kill natural predators.'
  ),
  'target spot': TreatmentProtocol(
    directTreatment: 'Apply fungicide. Avoid overhead irrigation. Improve air circulation.',
    preventiveMeasures: 'Ensure crop spacing allows adequate sunlight to dry the lower canopy.',
    fertilizersPesticides: 'Apply chlorothalonil, mancozeb, or strobilurin-class fungicides.'
  ),
  'yellow leaf curl': TreatmentProtocol(
    directTreatment: 'Control whiteflies with insecticides. Use reflective mulch. Remove infected plants.',
    preventiveMeasures: 'Install insect-proof screens (50-mesh) on greenhouse ventilation windows.',
    fertilizersPesticides: 'Use imidacloprid systemic drench during transplanting to suppress whitefly vectors.'
  ),
  'mosaic virus': TreatmentProtocol(
    directTreatment: 'Remove infected plants. Control aphids. Disinfect tools. No chemical cure.',
    preventiveMeasures: 'Remove weed hosts from borders and wash hands/tools with soap or milk solution.',
    fertilizersPesticides: 'No chemical cure. Spray mineral oils to reduce aphid transmission rates.'
  ),
  'leaf scorch': TreatmentProtocol(
    directTreatment: 'Apply fungicide. Remove scorched leaves. Maintain consistent soil moisture.',
    preventiveMeasures: 'Mulch plants to keep roots cool and water deeply during dry periods.',
    fertilizersPesticides: 'Apply potassium and organic fertilizers to help the crop recover from drought stress.'
  ),
};
