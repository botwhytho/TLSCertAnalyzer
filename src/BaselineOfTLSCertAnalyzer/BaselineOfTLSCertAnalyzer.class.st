Class {
	#name : #BaselineOfTLSCertAnalyzer,
	#superclass : #BaselineOf,
	#category : #BaselineOfTLSCertAnalyzer
}

{ #category : #baseline }
BaselineOfTLSCertAnalyzer >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'TLSCertAnalyzer' ]
]
