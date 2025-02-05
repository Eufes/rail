
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипОбъектаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОпределитьВыборТиповИзСписка(ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОпределитьВыборТиповИзСписка(ДанныеВыбора, СтандартнаяОбработка)
	 	
	СтандартнаяОбработка = Ложь;
	
	МассивТипов = Метаданные.ОпределяемыеТипы.MultiPort_ОбъектыОбмена.Тип.Типы(); 
	МассивТиповРегистровСведений = Метаданные.ПодпискиНаСобытия.MultiPort_ПриЗаписиРегистраСведений.Источник.Типы();
	
	// Дополняем типы 
	Для Каждого ТипОбъекта Из МассивТиповРегистровСведений Цикл
		МассивТипов.Добавить(ТипОбъекта);
	КонецЦикла;	
		
	СписокТиповДляВыбора = Новый СписокЗначений;
	Для Каждого ТипОбъекта Из МассивТипов Цикл
		
		ИмяТипа = XMLТип(ТипОбъекта).ИмяТипа;
		ОписаниеТипа 	= Новый ОписаниеТипов(ИмяТипа);
		СсылкаОбъекта 	= ОписаниеТипа.ПривестиЗначение();
		
		ВидМетаданного = Лев(ИмяТипа, Найти(ИмяТипа, ".") - 1);    
		Если ВидМетаданного = "DocumentRef" Тогда
			ИмяТипаОбъект = СтрЗаменить(ИмяТипа, "DocumentRef", "DocumentObject");
		ИначеЕсли ВидМетаданного = "CatalogRef" Тогда
			ИмяТипаОбъект = СтрЗаменить(ИмяТипа, "CatalogRef", "CatalogObject"); 
		Иначе
			ИмяТипаОбъект = СтрЗаменить(ИмяТипа, "Ref", "Object");
		КонецЕсли;
		
		Синоним = СсылкаОбъекта.Метаданные().Синоним;
		СписокТиповДляВыбора.Добавить(ИмяТипаОбъект, Синоним); 
		
	КонецЦикла;
	
	ДанныеВыбора = СписокТиповДляВыбора;
		
КонецПроцедуры

#КонецОбласти