﻿#Область EVatService

&НаСервере
Функция АдресВебСервисаЭСЧФ() Экспорт
	Возврат	Константы.АдресВебСервисаЭСЧФ.Получить();
КонецФункции	

#КонецОбласти

Функция ПолучитьТаблицуЭД(МассивДокументов, СоответствиеМакетовXSD = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияЭД.ЭлектронныйДокумент.НомерЭД КАК НомерЭД,
	|	СостоянияЭД.ЭлектронныйДокумент КАК ЭлектронныйДокумент,
	|	СостоянияЭД.СостояниеВерсииЭД КАК СостояниеВерсииЭД,
	|	СостоянияЭД.СсылкаНаОбъект КАК СсылкаНаОбъект,
	|	СостоянияЭД.СсылкаНаОбъект.ТипСчетаФактуры КАК ТипСчетаФактуры,
	|	""MNSATI_add_no_reference_XSD"" КАК Схема
	|ИЗ
	|	РегистрСведений.СостоянияЭСЧФ КАК СостоянияЭД
	|ГДЕ
	|	СостоянияЭД.СсылкаНаОбъект В(&МассивДокументов)
	|	И СостоянияЭД.СсылкаНаОбъект.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаДанных = Результат.Выгрузить();
	
	Если  СоответствиеМакетовXSD <> Неопределено Тогда
		
		Для Каждого ТекущаяСтрока ИЗ ТаблицаДанных Цикл
			
			ТекущаяСтрока.Схема = Справочники.ТипыЭСЧФ.ПолучитьСхемуПоТипуЭСЧФ(ТекущаяСтрока.ТипСчетаФактуры);	
			СоответствиеМакетовXSD.Вставить(ТекущаяСтрока.Схема, Справочники.ТипыЭСЧФ.ПолучитьМакетXSDПоТипуЭСЧФ(ТекущаяСтрока.ТипСчетаФактуры));	
			
		КонецЦикла;
		
	КонецЕсли;	
	
	Возврат ПреобразоватьТаблицуЗначенийВМассив(ТаблицаДанных);
	
КонецФункции

Функция ПреобразоватьТаблицуЗначенийВМассив(тзДанные) Экспорт
    
    мсДанные = Новый Массив;
        
    // Запишем в массив
    Для Каждого СтрокаТЗ Из тзДанные Цикл
        
        стСтрокаТаблицы = Новый Структура;
        Для Каждого ИмяКолонки Из тзДанные.Колонки Цикл
            стСтрокаТаблицы.Вставить(ИмяКолонки.Имя, СтрокаТЗ[ИмяКолонки.Имя]);
        КонецЦикла;
        
        мсДанные.Добавить(стСтрокаТаблицы);
        
    КонецЦикла;
    
    Возврат мсДанные;
    
КонецФункции // ПреобразоватьТаблицуЗначенийВМассив()

Процедура СформироватьЭлектронныйДокумент(МассивСсылок, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЭлектронныеСчетаФактуры.УдалитьНедоступныеДляФормированияЭСЧФОбъекты(МассивСсылок);
	Если МассивСсылок.Количество() = 0 Тогда
		Возврат 
	КонецЕсли;
	
	ЭлектронныеСчетаФактуры.СформироватьЭлектронныйДокумент(МассивСсылок);
	
КонецПроцедуры	

