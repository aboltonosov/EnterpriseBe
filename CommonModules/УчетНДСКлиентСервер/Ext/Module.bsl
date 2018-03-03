﻿
////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции формирования отчетности по НДС.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Рассчитывает сумму НДС исходя из суммы и флагов налогообложения.
//
// Параметры: 
//  Сумма            - число, сумма от которой надо рассчитывать налоги. 
//  СуммаВключаетНДС - булево, признак включения НДС в сумму ("внутри" или "сверху").
//  СтавкаНДС        - число , процентная ставка НДС.
//
// Возвращаемое значение:
//  Число, полученная сумма НДС.
//
Функция РассчитатьСуммуНДС(Сумма, СуммаВключаетНДС, СтавкаНДС) Экспорт

	Если СуммаВключаетНДС Тогда
		СуммаБезНДС = 100 * Сумма / (100 + СтавкаНДС);
		СуммаНДС = Сумма - СуммаБезНДС;
	Иначе
		СуммаБезНДС = Сумма;
	КонецЕсли;

	Если НЕ СуммаВключаетНДС Тогда
		СуммаНДС = СуммаБезНДС * СтавкаНДС / 100;
	КонецЕсли;
	
	Возврат СуммаНДС;

КонецФункции // РассчитатьСуммуНДС()

// Производит пересчет цен при изменении флагов учета налогов.
// Пересчет зависит от способа заполнения цен, при заполнении По ценам номенклатуры (при продаже) 
// хочется избегать ситуаций, когда компания  «теряет деньги» при пересчете налогов. 
// Поэтому если в документе флаг "Учитывать налог" выключен, то цены должны браться напрямую из справочника, 
// потому что хочется продавать по той же цене, независимо от режима налогообложения. 
// Например, если отпускная цена задана с НП для избежания ошибок округления, то это не значит, 
// что при отпуске без НП мы должны продать дешевле. Если же флаг учета налога в документе включен, 
// то цены должны пересчитываться при подстановке в документ: 
// налог должен включаться или не включаться в зависимости от флага включения налога в типе цен.
// При заполнении по ценам контрагентов (при покупке) хочется хранить цены поставщиков. 
// Поэтому нужно пересчитывать всегда по установленным флагам в документе и в типе цен. 
// Это гарантирует, что при записи цен в регистр и последующем их чтении, 
// например, при заполнении следующего документа, мы с точностью до ошибок округления при пересчете 
// получим те же самые цены.
//
// Параметры: 
//  Цена                - число, пересчитываемое значение цены.
//  ЦенаВключаетНДС     - булево, определяет содержит ли переданное значение цены НДС.
//  СуммаВключаетНДС    - булево, определяет должно ли новое значение цены включать НДС.
//  СтавкаНДС           - число, ставка НДС.
//
// Возвращаемое значение:
//  Число, новое значение цены.
//
Функция ПересчитатьЦенуПриИзмененииФлаговНалогов(Цена, ЦенаВключаетНДС,
						СуммаВключаетНДС, СтавкаНДС) Экспорт

	// Инициализация переменных
	НадоВключитьНДС  = Ложь;
	НадоИсключитьНДС = Ложь;
	НоваяЦена		 = Цена;

	Если СуммаВключаетНДС
		И (НЕ ЦенаВключаетНДС) Тогда
		
		// Надо добавлять НДС       
		НадоВключитьНДС = Истина;
	ИначеЕсли (НЕ СуммаВключаетНДС)
		И ЦенаВключаетНДС  Тогда
		
		// Надо исключать НДС       
		НадоИсключитьНДС = Истина;
	КонецЕсли;
		
	Если НадоИсключитьНДС Тогда
		НоваяЦена = (НоваяЦена * 100) / (100 + СтавкаНДС);
	КонецЕсли;

	Если НадоВключитьНДС Тогда
		НоваяЦена = (НоваяЦена * (100 + СтавкаНДС)) / 100;
	КонецЕсли;

	Возврат НоваяЦена;

КонецФункции // ПересчитатьЦенуПриИзмененииФлаговНалогов()

// Возвращает номер версии подсистемы НДС.
//
Функция Версия(Дата) Экспорт
	
	Возврат 2;
	
КонецФункции

// Определяет версию перечня кодов видов операций для отчетности по НДС на переданную дату.
//
// Параметры:
//   Период - Дата - дата, на которую требуется определить версию перечня видов операций.
// Возвращаемое значение:
//  Число - номер версии кодов видов операций
//          1 - перечень, утвержденный приказом ФНС 14.02.2012 N ММВ-7-3/83@.
//          2 - перечень, утвержденный письмом ФНС от 22.01.2015 N ГД-4-3/794@.
//          3 - перечень, утвержденный приказом ФНС от 14.03.2016 N ММВ-7-3/136@.
//
Функция ВерсияКодовВидовОпераций(Период) Экспорт
	
	Если Период >= '20160701' Тогда
		// С 1 июля 2016 года действует перечень, 
		// утвержденный приказом ФНС от 14.03.2016 N ММВ-7-3/136@.
		Возврат 3;
	ИначеЕсли Период >= '20150101' Тогда
		// С 1 января 2015 года действует перечень,
		// утвержденный письмом ФНС от 22.01.2015 N ГД-4-3/794@.
		Возврат 2;
	Иначе
		// До 1 января 2015 года действует перечень,
		// утвержденный приказом ФНС 14.02.2012 N ММВ-7-3/83@.
		Возврат 1;
	КонецЕсли;
	
КонецФункции

// Документы по учету НДС для передачи в электронном виде

// Возвращает код периода для передачи книг и журналов по НДС в электронном виде
//
Функция ПолучитьКодПоСКНП(Период, Реорганизация = Ложь) Экспорт 
	
	Мес = Цел((Месяц(Период) - 1)/3);
	
	Если Реорганизация Тогда
		Если Мес = 0 Тогда
			Возврат "51";
		ИначеЕсли Мес = 1 Тогда 
			Возврат "54";
		ИначеЕсли Мес = 2 Тогда 
			Возврат "55";
		ИначеЕсли Мес = 3 Тогда 
			Возврат "56";
		КонецЕсли;
	Иначе
		Если Мес = 0 Тогда
			Возврат "21";
		ИначеЕсли Мес = 1 Тогда 
			Возврат "22";
		ИначеЕсли Мес = 2 Тогда 
			Возврат "23";
		ИначеЕсли Мес = 3 Тогда 
			Возврат "24";
		КонецЕсли;	
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#Область УправлениеФормой

// Отображает текстовое пояснение по корректности выбора периода формирования отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//
Процедура ОтобразитьПоясненияКПериодуОтчета(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Объект = Форма.Отчет;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Элементы.ПояснениеРасширенныйНалоговыйПериод.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	БлижайшийНалоговыйПериод = УчетНДСВызовСервера.БлижайшийНалоговыйПериодСервер(
		Объект.Организация,
		Объект.КонецПериода);
	
	УчетВедется = Объект.КонецПериода >= НачалоКвартала(БлижайшийНалоговыйПериод.Начало);
	
	Если БлижайшийНалоговыйПериод.Конец = КонецДня(КонецКвартала(Объект.КонецПериода))
	   И КонецКвартала(БлижайшийНалоговыйПериод.Начало) < КонецКвартала(БлижайшийНалоговыйПериод.Период) Тогда
		
		// Расширенный налоговый период
		
		Элементы.ПояснениеРасширенныйНалоговыйПериод.Видимость = Истина;
		ШаблонСообщения = НСтр("ru='Период с даты регистрации %1 по %2 включается в отчетность по НДС за %3.'");
		ТекстПояснения = СтрШаблон(
			ШаблонСообщения,
			Формат(БлижайшийНалоговыйПериод.Начало, "ДЛФ=D"), 
			Формат(КонецКвартала(БлижайшийНалоговыйПериод.Начало), "ДЛФ=D"),
			Формат(БлижайшийНалоговыйПериод.Конец, "ДФ='к ''квартал'' гггг ''года'''"));
		Элементы.ПояснениеРасширенныйНалоговыйПериод.Заголовок = ТекстПояснения;
		
	ИначеЕсли УчетВедется 
		    И БлижайшийНалоговыйПериод.Конец > КонецДня(КонецКвартала(Объект.КонецПериода)) Тогда
		Элементы.ПояснениеРасширенныйНалоговыйПериод.Видимость = Истина;
		ШаблонСообщения = НСтр("ru='Отчетность по НДС за %1 сдавать не нужно. Период с даты регистрации %2 по %3 включается в отчетность за %4.'");
		ТекстПояснения = СтрШаблон(
			ШаблонСообщения,
			Формат(КонецКвартала(Объект.КонецПериода), "ДФ='к ''квартал'' гггг ''года'''"),
			Формат(БлижайшийНалоговыйПериод.Начало, "ДЛФ=D"), 
			Формат(КонецКвартала(БлижайшийНалоговыйПериод.Начало), "ДЛФ=D"),
			Формат(БлижайшийНалоговыйПериод.Конец, "ДФ='к ''квартал'' гггг ''года'''"));
		Элементы.ПояснениеРасширенныйНалоговыйПериод.Заголовок = ТекстПояснения;
	Иначе
		Элементы.ПояснениеРасширенныйНалоговыйПериод.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

// Вызывается их обработчиков при смене организации в формах отчетов по НДС.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//
Процедура ФормаОтчетаОрганизацияПериодПриИзменении(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	ОтобразитьПоясненияКПериодуОтчета(Форма);
	
	Если НЕ ЗначениеЗаполнено(Форма.ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#КонецОбласти