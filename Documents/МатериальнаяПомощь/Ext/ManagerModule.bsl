﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Проводит документ по учетам. Если в параметре ВидыУчетов передано Неопределено, то документ проводится по всем учетам.
// Процедура вызывается из обработки проведения и может вызываться из вне.
// 
// Параметры:
//  ДокументСсылка	- ДокументСсылка.МатериальнаяПомощь - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.МатериальнаяПомощь - Передается только при вызове из обработки проведения документа
//  ДополнительныеПараметры - Структура - Дополнительные параметры, необходимые для проведения документа
//
Процедура ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов = Неопределено, Движения = Неопределено, Объект = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
	ПроведениеРасширенныйСервер.ПодготовитьНаборыЗаписейКРегистрацииДвиженийПоВидамУчета(РежимПроведения, ДокументСсылка, СтруктураВидовУчета, ВидыУчетов, Движения, Объект, Отказ, Ложь);
	
	РеквизитыДляПроведения = РеквизитыДляПроведения(ДокументСсылка);
	ДанныеДляПроведения = ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета);
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
	
		МесяцНачисления	= РеквизитыДляПроведения.ПериодРегистрации;
		
		ДатаОперации	= УчетНДФЛРасширенный.ДатаОперацииПоДокументу(РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.ПериодРегистрации);
		МесяцНачисления	= РеквизитыДляПроведения.ПериодРегистрации;
			
		// Начисления
		РасчетЗарплатыРасширенный.СформироватьДвиженияНачислений(
			Движения, Отказ, РеквизитыДляПроведения.Организация, МесяцНачисления, ДанныеДляПроведения.Начисления, ДанныеДляПроведения.ПоказателиНачислений, Истина);
		
		РасчетЗарплатыРасширенный.СформироватьДвиженияРаспределенияПоТерриториямУсловиямТруда(Движения, Отказ, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда);
			
		// Удержания
		РасчетЗарплатыРасширенный.СформироватьДвиженияУдержаний(Движения, Отказ, РеквизитыДляПроведения.Организация, ДатаОперации, ДанныеДляПроведения.Удержания, ДанныеДляПроведения.ПоказателиУдержаний);
		ИсполнительныеЛисты.СформироватьУдержанияПоИсполнительнымДокументам(Движения, ДанныеДляПроведения.УдержанияПоИсполнительнымДокументам);
		
		// - Регистрация бухучета начислений и удержаний, выполняется до вызова регистрации доходов в учете НДФЛ.
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
					Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации,
					ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.УдержанияПоСотрудникам, Неопределено,
					РасчетЗарплатыРасширенный.ЭтоМежрасчетнаяВыплата(РеквизитыДляПроведения.ПорядокВыплаты));
		
		// НДФЛ
		УчетНДФЛРасширенный.ЗарегистрироватьДоходыИСуммыНДФЛПоВременнойТаблицеНачислений(
			РеквизитыДляПроведения.Ссылка, Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.ПериодРегистрации, РеквизитыДляПроведения.ПорядокВыплаты, РеквизитыДляПроведения.ПланируемаяДатаВыплаты, ДанныеДляПроведения, Истина, Истина);
		
		// КорректировкиВыплаты
		РасчетЗарплатыРасширенный.СформироватьДвиженияКорректировкиВыплатыПоВременнойТаблицеНачислений(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, РеквизитыДляПроведения.ПорядокВыплаты, ДанныеДляПроведения, Истина, Истина);
		
		// Учет начисленной зарплаты
		УчетНачисленнойЗарплаты.ЗарегистрироватьНачисленияУдержания(
			Движения, Отказ, РеквизитыДляПроведения.Организация, МесяцНачисления, ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.УдержанияПоСотрудникам, Неопределено, Неопределено, РеквизитыДляПроведения.ПорядокВыплаты);
		
		// - Регистрация бухучета НДФЛ, выполняется после вызова регистрации доходов в учете НДФЛ.
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
					Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации,
					Неопределено, Неопределено, ДанныеДляПроведения.НДФЛПоСотрудникам,
					РасчетЗарплатыРасширенный.ЭтоМежрасчетнаяВыплата(РеквизитыДляПроведения.ПорядокВыплаты));
		
		// Страховые взносы
		УчетСтраховыхВзносов.СформироватьСведенияОДоходахСтраховыеВзносы(Движения, Отказ, РеквизитыДляПроведения.Организация, МесяцНачисления, ДанныеДляПроведения.МенеджерВременныхТаблиц, Ложь, Истина, РеквизитыДляПроведения.Ссылка);
		
		ПерерасчетЗарплаты.УдалениеПерерасчетовПоДополнительнымПараметрам(РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
		
		// Учет среднего заработка
		УчетСреднегоЗаработка.ЗарегистрироватьДанныеСреднегоЗаработка(Движения, Отказ, ДанныеДляПроведения.НачисленияДляСреднегоЗаработка);
		
	КонецЕсли;
	
	ПроведениеРасширенныйСервер.ЗаписьДвиженийПоУчетам(Движения, СтруктураВидовУчета);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.МатериальнаяПомощь);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ о выплате материальной помощи.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
	КомандаПечати.Идентификатор = "ПФ_MXL_ПриказОВыплатеМатериальнойПомощи";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о выплате материальной помощи'");
	
КонецПроцедуры

// Функция создает таблицу с данными для бухучета.
//
// Параметры:
//	Объект - ДокументОбъект.МатериальнаяПомощь
//
// Возвращаемое значение:
//  Таблица значений
//
Функция ДанныеДляБухучетаЗарплатыПервичныхДокументов(Объект) Экспорт

	ДанныеДляБухучета = Новый Структура;
	ДанныеДляБухучета.Вставить("ДокументОснование", Объект.Ссылка);
	
	ТаблицаБухучетЗарплаты = ОтражениеЗарплатыВБухучетеРасширенный.НоваяТаблицаБухучетЗарплатыПервичныхДокументов();
	НоваяСтрока = ТаблицаБухучетЗарплаты.Добавить();
	НоваяСтрока.ДокументОснование = Объект.Ссылка;
	НоваяСтрока.НачислениеУдержание = Объект.ВидРасчета;
	НоваяСтрока.СпособОтраженияЗарплатыВБухучете = Объект.СпособОтраженияЗарплатыВБухучете;
	НоваяСтрока.ОтношениеКЕНВД = Объект.ОтношениеКЕНВД;
	НоваяСтрока.СтатьяФинансирования = Объект.СтатьяФинансирования;
	НоваяСтрока.СтатьяРасходов = Объект.СтатьяРасходов;
	
	ДанныеДляБухучета.Вставить("ТаблицаБухучетЗарплаты", ТаблицаБухучетЗарплаты);
	
	Возврат ДанныеДляБухучета;
	
КонецФункции 

Функция ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета) 
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		РасчетЗарплатыРасширенный.ЗаполнитьНачисления(
			ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления,НачисленияПерерасчет", "Ссылка.ПериодРегистрации", "Ссылка.ВидРасчета");
		
		ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВД(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоСотрудникам);
		
		РасчетЗарплатыРасширенный.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления");
		РасчетЗарплаты.ЗаполнитьУдержания(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплатыРасширенный.ЗаполнитьДанныеКорректировкиВыплаты(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
		ДополнительныеПараметры = УчетСреднегоЗаработка.ДополнительныеПараметрыРегистрацииДанныхСреднегоЗаработка();
		ДополнительныеПараметры.МесяцНачисления = "Ссылка.ПериодРегистрации";
		ДополнительныеПараметры.Таблицы.Начисления.Начисление = "Ссылка.ВидРасчета";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаДействия = "Ссылка.ПериодРегистрации";
		ДополнительныеПараметры.Таблицы.Начисления.НачалоБазовогоПериода = "Ссылка.ПериодРегистрации";
		ДополнительныеПараметры.Таблицы.Начисления.ОкончаниеБазовогоПериода = "Ссылка.ПериодРегистрации";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаНачала = "Ссылка.ПериодРегистрации";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаОкончания = "Ссылка.ПериодРегистрации";
		УчетСреднегоЗаработка.ЗаполнитьТаблицыДляРегистрацииДанныхСреднегоЗаработка(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведения(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МатериальнаяПомощь.Ссылка,
	|	МатериальнаяПомощь.Дата,
	|	МатериальнаяПомощь.Организация,
	|	МатериальнаяПомощь.ПериодРегистрации,
	|	МатериальнаяПомощь.ПорядокВыплаты,
	|	МатериальнаяПомощь.ПланируемаяДатаВыплаты
	|ИЗ
	|	Документ.МатериальнаяПомощь КАК МатериальнаяПомощь
	|ГДЕ
	|	МатериальнаяПомощь.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МатериальнаяПомощьРаспределениеПоТерриториямУсловиямТруда.НомерСтроки,
	|	МатериальнаяПомощьРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтроки,
	|	МатериальнаяПомощьРаспределениеПоТерриториямУсловиямТруда.Территория,
	|	МатериальнаяПомощьРаспределениеПоТерриториямУсловиямТруда.УсловияТруда,
	|	МатериальнаяПомощьРаспределениеПоТерриториямУсловиямТруда.ДоляРаспределения,
	|	МатериальнаяПомощьРаспределениеПоТерриториямУсловиямТруда.Результат,
	|	МатериальнаяПомощьРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтрокиПоказателей
	|ИЗ
	|	Документ.МатериальнаяПомощь.РаспределениеПоТерриториямУсловиямТруда КАК МатериальнаяПомощьРаспределениеПоТерриториямУсловиямТруда
	|ГДЕ
	|	МатериальнаяПомощьРаспределениеПоТерриториямУсловиямТруда.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результаты = Запрос.ВыполнитьПакет();
	
	РеквизитыДляПроведения = РеквизитыДляПроведенияПустаяСтруктура();
	
	ВыборкаРеквизиты = Результаты[0].Выбрать();
	
	Пока ВыборкаРеквизиты.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, ВыборкаРеквизиты);
		
	КонецЦикла;
	
	РаспределениеПоТерриториямУсловиямТруда = Результаты[1].Выгрузить();
	
	РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда = РаспределениеПоТерриториямУсловиямТруда;
	
	Возврат РеквизитыДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведенияПустаяСтруктура()
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура("ПериодРегистрации, Дата, Организация, ПорядокВыплаты, ПланируемаяДатаВыплаты, Ссылка, РаспределениеПоТерриториямУсловиямТруда");	
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

#КонецОбласти

#КонецЕсли
