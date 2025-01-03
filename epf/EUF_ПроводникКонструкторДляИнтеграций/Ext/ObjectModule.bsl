﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ВыполнитьОбработчикОбмена(ИсходящееСообщение, НастройкиПоТипуСообщения, ПодключенаВнешняя = Ложь) Экспорт
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("ОписаниеФормата", "json");
	
	ПредставлениеИнтеграционногоПроцесса = Строка(НастройкиПоТипуСообщения.ИнтеграционныйПроцесс);
	
	EUF_ПроводникВызовСервера.ВыполнитьЛогирование("Выполнение подключаемого обработчика", УровеньЖурналаРегистрации.Информация, 
			"Обработка исходящего - " + ПредставлениеИнтеграционногоПроцесса, , Истина, ИсходящееСообщение);
	
	Попытка		
			
		ДанныеВФорматеТранспорта = СформироватьДанныеОбмена(СтруктураРезультат, ИсходящееСообщение, НастройкиПоТипуСообщения);
		СтруктураРезультат.Вставить("ДанныеВФорматеТранспорта", ДанныеВФорматеТранспорта);
		
	Исключение
		ТекстИсключения = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
		##н_mail
		ОтправитьСообщениеОбОшибке(ТекстИсключения, "Ошибка подготовки сообщения по выгрузке договоров контрагентов из ДО в УХ",
			"Техподдержка", НастройкиПоТипуСообщения, ИсходящееСообщение);
		##к_mail
		ВызватьИсключение ТекстИсключения;
	КонецПопытки;		
	
	Возврат СтруктураРезультат;
	
КонецФункции 

Функция ОбработатьВходящееСообщение(ВходящееСообщение, НастройкиПоТипуСообщения, ПодключенаВнешняя = Ложь) Экспорт
		
	Ответ = Новый Структура("Результат, ИнформацияОбОшибках", , "");
	
	ПредставлениеИнтеграционногоПроцесса = Строка(НастройкиПоТипуСообщения.ИнтеграционныйПроцесс);
	ТекстЛога = "Обработка входящего - " + ПредставлениеИнтеграционногоПроцесса;
	EUF_ПроводникВызовСервера.ВыполнитьЛогирование("Обработка входящего сообщения обработчиком", УровеньЖурналаРегистрации.Информация,
		ТекстЛога, , Истина, ВходящееСообщение);
	
	Попытка							
		
		ДанныеОбменаХранилищеЗначения = EUF_ПроводникОбмен.ПолучитьДанныеФорматаТранспорта(ВходящееСообщение);
		ДанныеОбмена = ДанныеОбменаХранилищеЗначения.Получить();
		Если ЗначениеЗаполнено(ДанныеОбмена) Тогда
			Если ТипЗнч(ДанныеОбмена) <> Тип("Строка") Тогда 
				ВызватьИсключение "Для входящего сообщения с кодом " + ВходящееСообщение.Код + " данные обмена не в строковом формате";				
			КонецЕсли;
		Иначе
			ВызватьИсключение "Для входящего сообщения с кодом " + ВходящееСообщение.Код + " не указаны данные обмена";	
		КонецЕсли;			
		
		ДвоичныеДанныеСтроки = Base64Значение(ДанныеОбмена);
		ДанныеОбменаРасшифрованные = ПолучитьСтрокуИзДвоичныхДанных(ДвоичныеДанныеСтроки);  
		
		// Прочитаем JSON и сформируем данные
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ДанныеОбменаРасшифрованные);
		СтруктураДанных = ПрочитатьJSON(ЧтениеJSON, , , ФорматДатыJSON.ISO);
		ЧтениеJSON.Закрыть();
		
		Если Лев(ВРег(НастройкиПоТипуСообщения.ТехническоеИмя), 41) = ВРег("kvitantsiya_v_do_ot_uh_vygruzka_dogovorov") Тогда
					
			ДанныеОбмена = ПреобразоватьМассивВТаблицуЗначений(СтруктураДанных.Результат);
			
			ИнформацияОбОшибках = СтруктураДанных.ИнформацияОбОшибках;
			
			Если ПустаяСтрока(ИнформацияОбОшибках) Тогда
				
				МассивОбъектов = Новый Массив;
				
				// запись в регистр соответствий
				ЗаписатьСоответствияВнешнихСсылок(ДанныеОбмена, ВходящееСообщение.ВнешняяСистема, МассивОбъектов);
				
				ВыполнитьСлужебнуюЗадачуВыгрузкиДоговораВУХ(ДанныеОбмена, ВходящееСообщение, НастройкиПоТипуСообщения.НастройкаСсылка);
				
				// сформируем обратное сообщение для передачи исполнителей договора
				ОтправитьСообщениеВыгрузкиИсполнителейДоговора(ДанныеОбмена, ВходящееСообщение, Ответ);
				
				СвязатьОбъектИнтеграцииССообщением(ВходящееСообщение);
				
			КонецЕсли;
			
		ИначеЕсли ВРег(НастройкиПоТипуСообщения.ТехническоеИмя) = ВРег("vygruzka_statusa_dogovora_iz_do_v_uh") Тогда
			ДанныеОбмена = СтруктураДанных.ДанныеОбмена;
			
			ПодготовитьДанныеСтатусаДоговора(ДанныеОбмена, ВходящееСообщение, Ответ);
		КонецЕсли;
		
		ИДСообщения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВходящееСообщение, "ИдентификаторВоВнешнейСистеме");
		ТекстИнформации = "Сообщение " + ИДСообщения + " от 1С:Управление холдингом";
		EUF_ПроводникВызовСервера.ВыполнитьЛогирование("Обработка входящего сообщения обработчиком", УровеньЖурналаРегистрации.Информация,
			ТекстИнформации, , Истина, ВходящееСообщение);
	Исключение
		ТекстИсключения = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		СообщитьИСоздатьЗадачуБухгалтерииJIRA(ТекстИсключения, "Ошибка приема квитанции обмена договорами контрагентов от УХ в ДО",
			"Техподдержка", НастройкиПоТипуСообщения, ВходящееСообщение);
		ВызватьИсключение ТекстИсключения;							
	КонецПопытки;

	Ответ.ИнформацияОбОшибках = СокрЛП(Ответ.ИнформацияОбОшибках);
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	
	НастройкиСериализации = Новый НастройкиСериализацииJSON();
	НастройкиСериализации.СериализовыватьМассивыКакОбъекты = Ложь;
	НастройкиСериализации.ФорматСериализацииДаты = ФорматДатыJSON.ISO;
	НастройкиСериализации.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.ЛокальнаяДата;
	
	ЗаписатьJSON(ЗаписьJSON, Ответ, НастройкиСериализации);
	
	СтрокаОтвет = ЗаписьJSON.Закрыть();
	
	Возврат СтрокаОтвет;	
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВспомогательныеПроцедурыИФункции // ******************************************

Процедура ОтправитьСообщениеОбОшибке(ТекстПисьма, ТемаПисьма, ИДГруппыАдресатов, НастройкиПоТипуСообщения, СсылкаНаСообщение)
	
	ЗаголовокЛогирования = "Выполнение подключаемого обработчика";

	// Проверяем количество попыток - если израсходованы все, то отправляем письмо	
	ИнтеграционныйПроцесс = НастройкиПоТипуСообщения.ИнтеграционныйПроцесс;
	
	// Отправка с учетом попыток
	Если НастройкиПоТипуСообщения.ИзрасходованоПопыток + 1 < НастройкиПоТипуСообщения.ДоступноПопытокОбработки Тогда
		// Отправляем только если исчерпаны все попытки
		Возврат;
	КонецЕсли;	
	
	ПредставлениеСообщения = Строка(СсылкаНаСообщение); 
	Если ТипЗнч(СсылкаНаСообщение) = Тип("СправочникСсылка.EUF_ПроводникСообщенияИсходящие") Тогда
		НаправлениеСообщения = "Направление: исходящее соообщение ";
	ИначеЕсли ТипЗнч(СсылкаНаСообщение) = Тип("СправочникСсылка.EUF_ПроводникСообщенияВходящие") Тогда	
		НаправлениеСообщения = "Направление: входящее соообщение ";
	Иначе	
		НаправлениеСообщения = "Направление: неопределено сообщение ";
	КонецЕсли;	
	ТекстПисьма = "Интеграционный процесс - " + Строка(ИнтеграционныйПроцесс) + Символы.ПС
					+ НаправлениеСообщения + ПредставлениеСообщения + Символы.ПС + ТекстПисьма;
	
	УчетнаяЗапись = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ИнтеграционныйПроцесс, "Отправитель");  	
	Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Возврат;
	КонецЕсли;
	
	// Параметры письма
	ПараметрыПисьма = СформироватьПараметрыПисьма(ТемаПисьма, ИДГруппыАдресатов, ИнтеграционныйПроцесс);
		
	Если Не ЗначениеЗаполнено(ПараметрыПисьма) Тогда
		ТекстОшибки = "Не удалось отправить письмо: Не определены получатели";
		EUF_ПроводникВызовСервера.ВыполнитьЛогирование(ЗаголовокЛогирования,
					УровеньЖурналаРегистрации.Информация,
					ТекстОшибки, ,
					Истина, СсылкаНаСообщение);		
		Возврат;
	КонецЕсли;
	
	ПараметрыПисьма.Вставить("ТипТекста", Перечисления.ТипыТекстовЭлектронныхПисем.РазмеченныйТекст);
	ПараметрыПисьма.Вставить("Тело",      ТекстПисьма);
		
	Попытка
		Письмо = РаботаСПочтовымиСообщениями.ПодготовитьПисьмо(УчетнаяЗапись, ПараметрыПисьма);
		РезультатОтправки = РаботаСПочтовымиСообщениями.ОтправитьПисьмо(УчетнаяЗапись, Письмо);
		РаботаСПочтовымиСообщениямиПереопределяемый.ПослеОтправкиПисьма(ПараметрыПисьма);
		ОшибочныеПолучатели = РезультатОтправки.ОшибочныеПолучатели;
		ТекстОшибки = "";
		
		Для Каждого ОшибочныйПолучатель Из ОшибочныеПолучатели Цикл			
			ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1: %2'"),
				ОшибочныйПолучатель.Ключ, ОшибочныйПолучатель.Значение); 			
		КонецЦикла;
	Исключение 	
		ТекстОшибки = "Не удалось отправить письмо по следующей причине: " + ОписаниеОшибки(); 
		EUF_ПроводникВызовСервера.ВыполнитьЛогирование(ЗаголовокЛогирования, УровеньЖурналаРегистрации.Ошибка, ТекстОшибки, ,
					Истина, СсылкаНаСообщение);		
		Возврат;		
	КонецПопытки;
	
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		ТекстИнфо = "Следующие адресаты не получили письмо: " + ТекстОшибки;		
	Иначе
		ТекстИнфо = "Отправлено сообщение адресатам: " + ПараметрыПисьма.ПолучателиСтрокой;		
	КонецЕсли; 
	
	EUF_ПроводникВызовСервера.ВыполнитьЛогирование(ЗаголовокЛогирования, УровеньЖурналаРегистрации.Информация, ТекстИнфо, ,
					Истина, СсылкаНаСообщение);	

КонецПроцедуры  

Функция СформироватьПараметрыПисьма(ТемаПисьма, ГруппаАдресатов, ИнтеграционныйПроцесс)
		
	Адресаты = EUF_ПроводникНаВремяВызоваПовтИсп.ПолучитьАдресатовИнтеграционногоПроцесса(ИнтеграционныйПроцесс, ,
										ГруппаАдресатов);
	Если Не Адресаты.Количество() Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	ПараметрыПисьма = Новый Структура();
	
	Кому = Новый Массив;
	МассивАдресов = Новый Массив;
	Для Каждого ПочтовыйАдрес Из Адресаты Цикл
		Кому.Добавить(Новый Структура("Адрес, Представление", ПочтовыйАдрес.Адрес, ПочтовыйАдрес.Представление));
		МассивАдресов.Добавить(ПочтовыйАдрес.Адрес);
	КонецЦикла;
		
	ПараметрыПисьма.Вставить("Кому", Кому);
	ПараметрыПисьма.Вставить("Тема", ТемаПисьма);
	ПараметрыПисьма.Вставить("ПолучателиСтрокой", СтрСоединить(МассивАдресов, ";"));
	
	Возврат ПараметрыПисьма;
	
КонецФункции

#КонецОбласти // ВспомогательныеПроцедурыИФункции

Процедура СвязатьОбъектИнтеграцииССообщением(ИнтеграционноеСообщение, Дополнить = Ложь)
	
	обСообщение = ИнтеграционноеСообщение.ПолучитьОбъект();
	
	Если Не Дополнить Тогда
		обСообщение.ОбъектыОбмена.Очистить();
	КонецЕсли;			
	Для Каждого ЭлементОбъект Из МассивОбъектов Цикл
		НовСтр = обСообщение.ОбъектыОбмена.Добавить();
		НовСтр.ОбъектОбмена = ЭлементОбъект;
	КонецЦикла;
	обСообщение.Записать();
	
КонецПроцедуры

#КонецОбласти
 

#Область Инициализация

Функция СведенияОВнешнейОбработке() Экспорт

	МетаданныеОбработки = Метаданные();

	ВерсияБСП = Строка(СтандартныеПодсистемыСервер.ВерсияБиблиотеки());	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке(ВерсияБСП);
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();	
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();	
	ПараметрыРегистрации.Наименование = МетаданныеОбработки.Синоним;
	ПараметрыРегистрации.БезопасныйРежим = Истина; 
	ПараметрыРегистрации.Версия = НомерВерсииОбработки();    
	ПараметрыРегистрации.Информация = МетаданныеОбработки.Комментарий;
	
	#Область Разрешения
	
	Разрешения = ПараметрыРегистрации.Разрешения;  
	
	// Привелигированный режим
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеПривилегированногоРежима(
		"Для возможности создания обработчика под служебным пользователем, подключающегося по web или http");
	Разрешения.Добавить(Разрешение);
	
	// Указываем несколько параметров для возможности переключения способа подключения	
	// com
	ProgID = "v83.COMConnector";
	CLSID = ОбщегоНазначения.ИдентификаторCOMСоединителя(ProgID);
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаСозданиеCOMКласса(ProgID, CLSID, ,
						"Подключение к базам 1С через COM");
		
	// ws		
	СтруктураРазрешений = EUF_ПроводникОбщегоНазначения.ПолучитьРазрешенияНаИнтернетРесурс("docmng_qiwi_adaptercentral",
			"web", "Подключение к базам 1С через web сервис подсистемы обмена QIWI Адаптер");
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(СтруктураРазрешений.Протокол,
		СтруктураРазрешений.АдресРесурса, СтруктураРазрешений.Порт,	СтруктураРазрешений.Описание);			
	Разрешения.Добавить(Разрешение); 
	// hs
	СтруктураРазрешений = EUF_ПроводникОбщегоНазначения.ПолучитьРазрешенияНаИнтернетРесурс("docmng_qiwi_adaptercentral",
			"http", "Подключение к базам 1С через http сервис подсистемы обмена QIWI Адаптер");
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(СтруктураРазрешений.Протокол,
		СтруктураРазрешений.АдресРесурса, СтруктураРазрешений.Порт,	СтруктураРазрешений.Описание);			
	Разрешения.Добавить(Разрешение);
	
	// Почта	
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса("SMTP",
	"mail.qiwi.com", 587, "Отправка на почту при ошибках");
	Разрешения.Добавить(Разрешение);
	
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса("SMTP",
	"smtp1.osmp.ru", 25, "Отправка на почту при ошибках");
	Разрешения.Добавить(Разрешение);
	
	#КонецОбласти
	  
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = МетаданныеОбработки.Синоним + " (в фоне)";
	Команда.Идентификатор = "ФоновыйРежим";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.ПоказыватьОповещение = Истина;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция НомерВерсииОбработки() Экспорт 	
	Возврат "1.1"; 	
КонецФункции

#КонецОбласти 

#КонецЕсли

