<g:if test="${stringType == 'serviceName'}">
		<w:r>
			<w:rPr>
				<w:noProof/>
			</w:rPr>
			
			<w:pict>
				<v:shapetype>
					<v:path arrowok="t" fillok="f" o:connecttype="none"/>
					<o:lock v:ext="edit" shapetype="t"/>
				</v:shapetype>
				<v:shape id="_x0000_s1028" type="#_x0000_t32" 
						 style="position:absolute;margin-left:2.25pt;margin-top:22.5pt;width:452.25pt;height:0;z-index:251658240" 
						 o:connectortype="straight"/>
			</w:pict>
		</w:r>
		
		<w:r w:rsidR="00D54542" w:rsidRPr="00D54542">
			<w:rPr>
				<w:b/>
				<w:sz w:val="28"/>
				<w:szCs w:val="28"/>
			</w:rPr>
			<w:t>${serviceName}</w:t>
		</w:r>
</g:if>

<g:elseif test="${stringType == 'definition'}">
	<w:p>
		<w:r>
			<w:t>${definition}</w:t>
		</w:r>
	</w:p>
</g:elseif>
