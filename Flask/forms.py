from flask_wtf import FlaskForm
from wtforms import IntegerField, SelectMultipleField, SubmitField, widgets, SelectField
from cities import getCityDictionary

class MultiCheckboxField(SelectMultipleField):
	widget = widgets.ListWidget(prefix_label=False)
	option_widget = widgets.CheckboxInput()

class VisualizerForm(FlaskForm):

	mexicoCities = getCityDictionary()
	mex = [("ALL","ALL")]
	for key in sorted(mexicoCities.keys()):
		mex.append((key, key))

	statesCheckbox = MultiCheckboxField("Filter by states", choices=mex)
	numberOfStates = IntegerField("Max number of States to display")
	year = IntegerField("Filter by year")
	submit = SubmitField("Submit")

class ScatterForm(FlaskForm):

	mex = []
	mexicoCities = getCityDictionary()
	for key in sorted(mexicoCities.keys()):
		mex.append((key, key))

	statesCheckbox = SelectField("Filter by state", choices=mex)
	year = IntegerField("Filter by year")
	submit = SubmitField("Submit")

